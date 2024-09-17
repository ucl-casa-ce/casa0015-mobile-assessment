/*
  Optical Heart Rate Detection (PBA Algorithm) using the MAX30105 Breakout
  By: Nathan Seidle @ SparkFun Electronics
  Date: October 2nd, 2016
  https://github.com/sparkfun/MAX30105_Breakout

  This is a demo to show the reading of heart rate or beats per minute (BPM) using
  a Penpheral Beat Amplitude (PBA) algorithm.

  It is best to attach the sensor to your finger using a rubber band or other tightening
  device. Humans are generally bad at applying constant pressure to a thing. When you
  press your finger against the sensor it varies enough to cause the blood in your
  finger to flow differently which causes the sensor readings to go wonky.

  Hardware Connections (Breakoutboard to Arduino):
  -5V = 5V (3.3V is allowed)
  -GND = GND
  -SDA = A4 (or SDA)
  -SCL = A5 (or SCL)
  -INT = Not connected

  The MAX30105 Breakout can handle 5V or 3.3V I2C logic. We recommend powering the board with 5V
  but it will also run at 3.3V.
*/

// next section from second example

/*

Adapted from https://randomnerdtutorials.com/esp32-bluetooth-low-energy-ble-arduino-ide/

*/

/*
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleServer.cpp
    Ported to Arduino ESP32 by Evandro Copercini
    updates by chegewara
*/


// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

#include <algorithm>
#include <iostream>
#include <vector>
#include <cmath> 

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLEService.h>
#include <BLECharacteristic.h>
#include <BLEAdvertising.h>

BLEServer *pServer = nullptr;
BLEService *pService = nullptr;
BLECharacteristic *pCharacteristic = nullptr;
int counter = 0;


#include <Wire.h>
#include "MAX30105.h"

#include "heartRate.h"

MAX30105 particleSensor;

const byte HRV_SIZE = 20; //For averaging HRV
long hrvs[HRV_SIZE];
byte hrvSpot = 0;
double hrv = 0;

const byte RATE_SIZE = 6; //For averaging BPM
byte rates[RATE_SIZE]; //Array of heart rates
byte rateSpot = 0;
long lastBeat = 0; //Time at which the last beat occurred
byte intervalSpot = 0;
bool intervalsReady = false;
int intervalsCount = 0;

long lastBLE = 0;
float beatsPerMinute;
int beatAvg;

int currentIndex = 0;
long stableDelta = 0;
int missedCount = 0;
int missedBPM = 0;
const int maxMisses = 20;


void setup()
{
  Serial.begin(115200);
  Serial.println("Initializing...");

  // Initialize heart rate sensor
  if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) //Use default I2C port, 400kHz speed
  {
    Serial.println("MAX30102 was not found. Please check wiring/power. ");
    while (1);
  }
  Serial.println("Place your index finger on the sensor with steady pressure.");

  particleSensor.setup(); //Configure sensor with default settings
  particleSensor.setPulseAmplitudeRed(0x0A); //Turn Red LED to low to indicate sensor is running
  particleSensor.setPulseAmplitudeGreen(0); //Turn off Green LED

  //code for BLE setup
  Serial.begin(115200);
  Serial.println("Starting BLE work!");

  BLEDevice::init("BeatsMon");
  pServer = BLEDevice::createServer();
  pService = pServer->createService(SERVICE_UUID);
  pCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_NOTIFY
                                       );

  pCharacteristic->setValue("52b");
  pService->start();
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
  Serial.println("Characteristic defined! Now you can read it in your phone!");

  //test the std dev function
  //std::vector<int> interBeatIntervals = {1000, 1040, 1030, 1025, 1045}; // Sample data: inter-beat intervals in milliseconds
  //double rmssd = calculateRMSSD(interBeatIntervals);
  
}

void loop()
{
  long irValue = particleSensor.getIR();

  if (checkForBeat(irValue) == true)
  {
    //We sensed a beat!
    long delta = millis() - lastBeat;
    
    //if delta between beats is within an acceptable range, store it
    //if not ignore and increment the missed delta
    //only stable delta values to be used in calculating HRV
    if (delta > 235 && delta < 3000)
    {
      stableDelta = delta;

      if (intervalsReady)
      {
        hrvs[hrvSpot++] = (long)stableDelta; //Store this reading in the array
        hrvSpot %= HRV_SIZE; //Wrap variable

        ///// calc HRV
        hrv = calculateRMSSD(hrvs);
      }
      else {
        intervalsCount++;
        if (intervalsCount >= 20)
        {
          intervalsReady = true;
        }
      }
      
    }
    else
    {
      missedCount++;
      if (missedCount>maxMisses)
      {
        stableDelta = 0;
        missedCount = 0;
      }
    }

    lastBeat = millis();

    beatsPerMinute = 60 / (stableDelta / 1000.0);

    if (beatsPerMinute < 255 && beatsPerMinute > 20)
    {

      rates[rateSpot++] = (byte)beatsPerMinute; //Store this reading in the array
      rateSpot %= RATE_SIZE; //Wrap variable

      //Get average of readings
      /*
      beatAvg = 0;
      for (byte x = 0 ; x < RATE_SIZE ; x++)
        beatAvg += rates[x];
      beatAvg /= RATE_SIZE;
      */
      calculateAverage();
    }
    else
    {
      missedBPM++;
      if (missedBPM > maxMisses)
      {
        beatAvg = 0;
        missedBPM = 0;
      }
    }

  }

  //broadcast new values over BLE every nMillis
  long ms = millis();
  if (ms - lastBLE > 2000)
  {
    lastBLE = ms;
    std::string result = std::string("AvgBPM: ") + std::to_string(beatAvg) + " | Delta: " + std::to_string(stableDelta) + " | HRV: " + std::to_string(hrv) + " | IC: " + std::to_string(intervalsCount)+ " | ready: " + std::to_string(intervalsReady);

    pCharacteristic->setValue(result);
    pCharacteristic->notify(); // Send notification
    counter++;
  }

  Serial.print("IR=");
  Serial.print(irValue);
  Serial.print(", BPM=");
  Serial.print(beatsPerMinute);
  Serial.print(", Avg BPM=");
  Serial.print(beatAvg);

  if (irValue < 50000)
    Serial.print(" No finger?");

  Serial.println();
  delay(20);
}

//function to calculate the interval mean squared SD of the inter beat intervals
double calculateRMSSD(const long IBIs[]) {
    //if (IBIs.size() < 2) return 0.0; // Need at least two intervals to compute differences

    double sumOfSquares = 0.0;
    for (byte i = 1; i < HRV_SIZE; ++i) {
        int diff = IBIs[i] - IBIs[i - 1];
        sumOfSquares += pow(diff, 2);
    }

    double meanOfSquares = sumOfSquares / (HRV_SIZE - 1);
    return sqrt(meanOfSquares);
}

//calc avg excluding highest and lowest values to help remove bad readings
void calculateAverage() {

  //Sort the array
  std::sort(rates, rates + RATE_SIZE);

  // Calculate the sum excluding the highest and lowest
  for (byte x = 1; x < RATE_SIZE - 1; x++) { // Start from 1 and end at RATE_SIZE-1 to exclude the smallest and largest
      beatAvg += rates[x];
  }

  beatAvg /= (RATE_SIZE - 2);

}