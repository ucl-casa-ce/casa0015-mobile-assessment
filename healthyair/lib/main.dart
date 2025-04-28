import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Screens
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pollutant_detail_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_screen.dart';

// Services and Models
import 'models/air_quality_data.dart';
import 'services/location_service.dart';
import 'services/api_service.dart';
import 'providers/air_quality_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AirQualityProvider()),
      ],
      child: const HealthyAirApp(),
    ),
  );
}

class HealthyAirApp extends StatelessWidget {
  const HealthyAirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthy Air',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.lightBlue,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/pollutant-details': (context) => const PollutantDetailScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}