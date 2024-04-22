# Concern your hear rate

This app is designed for users who want to monitor their heart rate in real-time, inspired by insights gained from a recent bike fitting session. Understanding the heart rate is important for optimising exercise results. Recognising that regular fittings are not feasible for every time doing exercise, I've incorporated the Heat Rate 30102 sensor, which can conveniently be attached to gloves. This feature is especially handy during indoor sports activities. The sensor connects to an ESP8266, transmitting data to an MQTT server. The app then retrieves this data and displays it in a visual format on your smartphone, allowing you to easily monitor the heart rate during exercise.


## Features

- **Real-Time Heart Rate Monitoring**: Displays the current heart rate in real-time using pretty gauge widgets.
- **Graphical Trend Analysis**: Shows heart rate trends over the last hour, updating every minute.
- **User Authentication**: Includes a login and registration system to manage access.
- **Cross-Platform Compatibility**: Built with Flutter, making it available for both Android and iOS devices.

## Physical device

ESP8266 connection

https://github.com/xxu121/casa0015-mobile-assessment/tree/main/heartrate_0015

## Installation

To get a local copy up and running, follow these simple steps.

### Prerequisites

Before you begin, ensure you have Flutter installed on your system. If Flutter is not installed, follow the instructions on the [official Flutter website](https://flutter.dev/docs/get-started/install) to set it up based on your operating system.

### Step 1: Clone the Repository

Clone the repository to get the source code on your local machine. Use the following Git command:


git clone[https://github.com/your_username_/FollowYourHeart.git](https://github.com/xxu121/casa0015-mobile-assessment/tree/main)

### Step 2: Install Dependencies
Navigate into the project directory and install the required Flutter packages. Run the following command in your terminal:

cd FollowYourHeart

flutter pub get

This command retrieves all the necessary dependencies as defined in pubspec.yaml.


### Step 3: Set Up MQTT Broker
Ensure you have an MQTT broker set up and running. This project uses MQTT to receive real-time updates. If you do not have one, you can install Mosquitto, a lightweight open-source MQTT broker. Installation instructions can be found on the Mosquitto official website.


### Step 4: Configure MQTT Settings
Open the app's configuration file located at lib/config.dart. Ensure the MQTT settings (broker URL and port) match those of your MQTT broker setup. Update these settings accordingly

const String MQTT_BROKER = 'YOUR_BROKER_ADDRESS';

const int MQTT_PORT = YOUR_BROKER_PORT;


### Step 5: Run the Application
Once all configurations are in place, run the application using the following command in your terminal:


flutter run


## Usage
After launching the app, log in using the credentials (default admin account is admin/admin). The heart rate monitor starts automatically if the MQTT broker is properly configured and transmitting data.


## Screens
Login Screen: Enter your credentials to access the heart rate monitor.

<img width="447" alt="image" src="https://github.com/xxu121/casa0015-mobile-assessment/assets/146341729/0ecf75bf-2b1a-4424-8a57-0b612ca6cc48">

Heart Rate Monitor: View your current heart rate and historical data on a gauge and graph.

<img width="447" alt="image" src="https://github.com/xxu121/casa0015-mobile-assessment/assets/146341729/c3248f0d-4d16-4c62-8954-89cb06aea394">  <img width="447" alt="image" src="https://github.com/xxu121/casa0015-mobile-assessment/assets/146341729/f9c54a50-7213-4614-9ddc-7c4f94b0fe66">


Settings: Adjust settings and view app information.

<img width="447" alt="image" src="https://github.com/xxu121/casa0015-mobile-assessment/assets/146341729/ee21c725-26bb-43b0-9cad-3c669d7fb873"> <img width="447" alt="image" src="https://github.com/xxu121/casa0015-mobile-assessment/assets/146341729/61d17932-9b6a-44a5-a77f-ce76f3fe64b6">


## Roadmap

Add predictive analytics to forecast potential health risks based on collected data.

Integrate with additional health-monitoring devices for a more comprehensive health status overview.

Improve data security and user management.

## Contributing

GPT4 of Code Generation: Several snippets of the code, especially those involving complex logic and string manipulations, were suggested by GPT-4.


Wix of Web Generation: Utilizing Wix's robust platform, the project features a professionally designed landing page that enhances user engagement and effectively communicates the app's benefits.

## Acknowledgments

GPT-4: For generating documentation and providing code suggestions. 

Wix: For facilitating the creation of an engaging landing page.

Flutter Community: For ongoing support and resources.


##  Contact Details

Xincen, Xu: ucfnxxu@ucl.ac.uk

Project Link: https://github.com/xxu121/casa0015-mobile-assessment/tree/main

Web: [https://xuxincen695.wixsite.com/my-site](https://xuxincen695.wixsite.com/my-site)

Youtube: [https://youtu.be/TtNztpexAbg](https://youtu.be/TtNztpexAbg)
