import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/air_quality_data.dart';

class ApiService {
  // AQICN API token
  static const String _apiToken = 'a932b02ccb204ccf9e16bd3c46d82c7a967ab931'; 
  static const String _baseUrl = 'https://api.waqi.info/feed';

  // Get air quality by city name
  Future<AirQualityData> getAirQualityByCity(String city) async {
    final url = '$_baseUrl/$city/?token=$_apiToken';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['status'] == 'ok') {
          return AirQualityData.fromJson(jsonData);
        } else {
          throw Exception('API error: ${jsonData['data']}');
        }
      } else {
        throw Exception('Failed to load air quality data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching air quality data: $e');
    }
  }

  // Get air quality by geographic coordinates
  Future<AirQualityData> getAirQualityByGeo(double latitude, double longitude) async {
    final url = '$_baseUrl/geo:$latitude;$longitude/?token=$_apiToken';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['status'] == 'ok') {
          return AirQualityData.fromJson(jsonData);
        } else {
          throw Exception('API error: ${jsonData['data']}');
        }
      } else {
        throw Exception('Failed to load air quality data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching air quality data: $e');
    }
  }
}