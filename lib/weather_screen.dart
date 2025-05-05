import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  final Function(String)? onTemperatureRangeUpdate;
  const WeatherScreen({super.key, this.onTemperatureRangeUpdate});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? _weatherData;
  String _city = 'London';
  bool _isLoading = false;
  String _errorMessage = '';
  final Location _location = Location();

  // 获取定位权限
  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      setState(() => _errorMessage = 'The location permission was denied. Use the default London weather');
      _fetchWeather();
    }
  }

  // 获取天气数据
  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final data = await WeatherService.getWeatherByCity(_city);
      setState(() => _weatherData = data);
      
      // 当获取到天气数据后，通过回调函数传递温度范围
      if (widget.onTemperatureRangeUpdate != null && _weatherData != null) {
        final tempRange = '${_weatherData!['main']['temp_min']}°C ~ ${_weatherData!['main']['temp_max']}°C';
        widget.onTemperatureRangeUpdate!(tempRange);
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to get weather: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    //_checkLocationPermission();
    _fetchWeather(); // 保留数据加载逻辑

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: _fetchWeather,
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    if (_weatherData == null) {
      return const Center(child: Text('click refresh to get weather'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _WeatherInfoCard(
            icon: Icons.location_city,
            title: 'City',
            value: _weatherData!['name'],
          ),
          _WeatherInfoCard(
            icon: Icons.thermostat,
            title: 'Temperature',
            value: '${_weatherData!['main']['temp']}°C',
          ),
          _WeatherInfoCard(
            icon: Icons.thermostat_outlined,
            title: 'Temperature Range',
            value: '${_weatherData!['main']['temp_min']}°C ~ '
                 '${_weatherData!['main']['temp_max']}°C',
        ),
          _WeatherInfoCard(
            icon: Icons.cloud,
            title: 'Weather',
            value: _weatherData!['weather'][0]['description'],
          ),
          _WeatherInfoCard(
            icon: Icons.air,
            title: 'Wind speed',
            value: '${_weatherData!['wind']['speed']} m/s',
          ),
        ],
      ),
    );
  }
}

class _WeatherInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _WeatherInfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: Text(value, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}