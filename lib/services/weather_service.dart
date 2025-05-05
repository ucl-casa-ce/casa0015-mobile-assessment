import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class WeatherService {
  static const String _apiKey = 'f7101260f8028886f1654c8a8b3a94b4';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // 通过城市名称获取天气
  static Future<Map<String, dynamic>> getWeatherByCity(String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=en'),
    );
    return _handleResponse(response);
  }

  // 通过定位获取天气
  static Future<Map<String, dynamic>> getWeatherByLocation() async {
    final location = await Location().getLocation();
    final response = await http.get(
      Uri.parse('$_baseUrl?lat=${location.latitude}&lon=${location.longitude}&appid=$_apiKey&units=metric&lang=en'),
    );
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather: ${response.statusCode}');
    }
  }
}