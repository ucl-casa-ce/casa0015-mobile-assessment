import 'package:flutter/material.dart';

class AirQualityData {
  final int aqi;
  final Map<String, PollutantData> pollutants;
  final String city;
  final String time;
  final String dominantPollutant;

  AirQualityData({
    required this.aqi,
    required this.pollutants,
    required this.city,
    required this.time,
    required this.dominantPollutant,
  });

  factory AirQualityData.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    
    // Extract pollutant data
    Map<String, PollutantData> pollutantsMap = {};
    
    if (data['iaqi'] != null) {
      final iaqi = data['iaqi'];
      
      if (iaqi['pm25'] != null) {
        pollutantsMap['pm25'] = PollutantData(
          name: 'PM2.5',
          value: iaqi['pm25']['v'].toDouble(),
          unit: 'μg/m³',
        );
      }
      
      if (iaqi['pm10'] != null) {
        pollutantsMap['pm10'] = PollutantData(
          name: 'PM10',
          value: iaqi['pm10']['v'].toDouble(),
          unit: 'μg/m³',
        );
      }
      
      if (iaqi['o3'] != null) {
        pollutantsMap['o3'] = PollutantData(
          name: 'O₃',
          value: iaqi['o3']['v'].toDouble(),
          unit: 'μg/m³',
        );
      }
      
      if (iaqi['no2'] != null) {
        pollutantsMap['no2'] = PollutantData(
          name: 'NO₂',
          value: iaqi['no2']['v'].toDouble(),
          unit: 'μg/m³',
        );
      }
      
      if (iaqi['so2'] != null) {
        pollutantsMap['so2'] = PollutantData(
          name: 'SO₂',
          value: iaqi['so2']['v'].toDouble(),
          unit: 'μg/m³',
        );
      }
      
      if (iaqi['co'] != null) {
        pollutantsMap['co'] = PollutantData(
          name: 'CO',
          value: iaqi['co']['v'].toDouble(),
          unit: 'mg/m³',
        );
      }
    }

    return AirQualityData(
      aqi: data['aqi'],
      pollutants: pollutantsMap,
      city: data['city']['name'],
      time: data['time']['s'],
      dominantPollutant: data['dominentpol'] ?? '',
    );
  }

  // Get color based on AQI value
  Color getAQIColor() {
    if (aqi <= 50) {
      return Colors.green;
    } else if (aqi <= 100) {
      return Colors.yellow;
    } else if (aqi <= 150) {
      return Colors.orange;
    } else if (aqi <= 200) {
      return Colors.red;
    } else if (aqi <= 300) {
      return Colors.purple;
    } else {
      return Colors.brown;
    }
  }

  // Get status text based on AQI value
  String getAQIStatus() {
    if (aqi <= 50) {
      return 'Good';
    } else if (aqi <= 100) {
      return 'Moderate';
    } else if (aqi <= 150) {
      return 'Unhealthy for Sensitive Groups';
    } else if (aqi <= 200) {
      return 'Unhealthy';
    } else if (aqi <= 300) {
      return 'Very Unhealthy';
    } else {
      return 'Hazardous';
    }
  }
}

class PollutantData {
  final String name;
  final double value;
  final String unit;

  PollutantData({
    required this.name,
    required this.value,
    required this.unit,
  });

  // Get color based on pollutant value
  Color getColor() {
    switch (name) {
      case 'PM2.5':
        if (value <= 12) return Colors.green;
        if (value <= 35.4) return Colors.yellow;
        if (value <= 55.4) return Colors.orange;
        if (value <= 150.4) return Colors.red;
        if (value <= 250.4) return Colors.purple;
        return Colors.brown;
        
      case 'PM10':
        if (value <= 54) return Colors.green;
        if (value <= 154) return Colors.yellow;
        if (value <= 254) return Colors.orange;
        if (value <= 354) return Colors.red;
        if (value <= 424) return Colors.purple;
        return Colors.brown;
        
      case 'O₃':
        if (value <= 54) return Colors.green;
        if (value <= 70) return Colors.yellow;
        if (value <= 85) return Colors.orange;
        if (value <= 105) return Colors.red;
        if (value <= 200) return Colors.purple;
        return Colors.brown;
        
      case 'NO₂':
        if (value <= 53) return Colors.green;
        if (value <= 100) return Colors.yellow;
        if (value <= 360) return Colors.orange;
        if (value <= 649) return Colors.red;
        if (value <= 1249) return Colors.purple;
        return Colors.brown;
        
      default:
        return Colors.blue;
    }
  }

  // Get health recommendation based on pollutant and its value
  String getHealthRecommendation() {
    switch (name) {
      case 'PM2.5':
        if (value <= 12) return 'Air quality is good. You can carry out outdoor activities as usual.';
        if (value <= 35.4) return 'Sensitive groups should reduce prolonged or intense outdoor activities.';
        if (value <= 55.4) return 'Sensitive groups should avoid outdoor activities. General public should reduce outdoor activities. Consider wearing a mask.';
        if (value <= 150.4) return 'Sensitive groups should avoid going out. General public should reduce outdoor activities. Consider wearing an N95 mask.';
        return 'Everyone should avoid outdoor activities. If going out, wear an N95 mask and minimize activity time.';
        
      case 'PM10':
        if (value <= 54) return 'Air quality is good. You can carry out outdoor activities as usual.';
        if (value <= 154) return 'Sensitive groups should reduce outdoor activities. Respiratory discomfort may occur.';
        if (value <= 254) return 'Sensitive groups should avoid outdoor activities. General public should reduce outdoor activities. Consider wearing a mask.';
        return 'Everyone should avoid outdoor activities. If going out, wear a mask and minimize activity time.';
        
      case 'O₃':
        if (value <= 54) return 'Air quality is excellent. You can carry out outdoor activities as usual.';
        if (value <= 70) return 'Very few sensitive individuals should reduce intense outdoor activities.';
        if (value <= 85) return 'Sensitive groups should reduce outdoor activities, especially in the afternoon and evening.';
        return 'Everyone, especially sensitive groups, should avoid outdoor activities. Ozone pollution usually peaks in the sunny afternoon.';
        
      case 'NO₂':
        if (value <= 53) return 'Air quality is good. You can carry out outdoor activities as usual.';
        if (value <= 100) return 'Sensitive groups may experience respiratory symptoms. Reduce outdoor activities.';
        if (value <= 360) return 'May affect the respiratory system of all groups. Sensitive groups should avoid outdoor activities.';
        return 'Everyone should reduce or avoid outdoor activities. May worsen respiratory diseases.';
        
      default:
        return 'Please monitor the current air quality and take precautions.';
    }
  }
}