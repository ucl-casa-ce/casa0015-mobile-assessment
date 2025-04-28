import 'package:flutter/foundation.dart';
import '../models/air_quality_data.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class AirQualityProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();
  
  AirQualityData? _airQualityData;
  String _currentCity = '';
  String _formattedCity = ''; // Add this field for the formatted city name
  bool _isLoading = false;
  String? _error;
  
  // Getters
  AirQualityData? get airQualityData => _airQualityData;
  String get currentCity => _currentCity;
  String get formattedCity => _formattedCity; // Add this getter for the formatted city name
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Initialize location and fetch initial data
  Future<void> initializeLocationAndData() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Get user's current location
      final position = await _locationService.getCurrentPosition();
      
      // Get city name from coordinates
      final cityFromCoordinates = await _locationService.getCityFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      // Get air quality data based on coordinates
      _airQualityData = await _apiService.getAirQualityByGeo(
        position.latitude,
        position.longitude,
      );

      // Use API-returned city name for _currentCity and format it for display
      _currentCity = _airQualityData!.city; // Use API-returned city name for API requests
      _formattedCity = _normalizeCityName(cityFromCoordinates); // Use geocoded city name for display

      _setLoading(false);
    } catch (e) {
      _setError('Initialization failed: $e');
      _setLoading(false);
    }
  }
  
  // Fetch air quality data for a specific city
  Future<void> fetchAirQualityForCity(String city) async {
    _setLoading(true);
    _clearError();
    
    try {
      _airQualityData = await _apiService.getAirQualityByCity(city);
      _currentCity = city; // Keep the original city name for API requests
      _formattedCity = _normalizeCityName(_airQualityData!.city); // Format city name for display
      _setLoading(false);
    } catch (e) {
      _setError('Failed to fetch data: $e');
      _setLoading(false);
    }
  }

  // Normalize city name format
  String _normalizeCityName(String city) {
    return city
        .split(' ')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '')
        .join(' ');
  }
  
  // Refresh current data
  Future<void> refreshData() async {
    if (_currentCity.isNotEmpty) {
      await fetchAirQualityForCity(_currentCity);
    } else {
      await initializeLocationAndData();
    }
  }
  
  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String errorMsg) {
    _error = errorMsg;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
    notifyListeners();
  }
}