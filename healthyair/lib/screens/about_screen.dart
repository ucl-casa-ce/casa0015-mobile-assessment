// lib/screens/about_screen.dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Healthy Air'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  // App logo
                  Image.asset(
                    'assets/logo.png', 
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Healthy Air',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            _buildSectionTitle('App Introduction'),
            const SizedBox(height: 8),
            const Text(
              'Healthy Air is a real-time air quality monitoring app designed to help users understand the air quality in their current location and provide corresponding health advice.',
              style: TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Data Source'),
            const SizedBox(height: 8),
            const Text(
              'This app uses real-time air quality data provided by the AQICN API. The data includes the Air Quality Index (AQI) and concentrations of various pollutants such as PM2.5, PM10, Ozone (O₃), Nitrogen Dioxide (NO₂), and more.',
              style: TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Privacy Policy'),
            const SizedBox(height: 8),
            const Text(
              'We highly value your privacy. The app requires location permissions to provide air quality data for your current location. All location data is used solely for retrieving local air quality information and will not be used for other purposes or shared with third parties.',
              style: TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Contact Us'),
            const SizedBox(height: 8),
            const Text(
              'If you have any questions, suggestions, or feedback, please contact us through the following methods:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Email: support@healthyair.app\n'
              'Website: www.healthyair.app',
              style: TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 32),
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.favorite, color: Colors.red),
                label: const Text('Thank you for using Healthy Air'),
                onPressed: () {}, 
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }
}