// lib/src/main_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app_state.dart';
import 'src/widgets.dart';
import 'weather_screen.dart';
import 'history_screen.dart';
import 'guest_book.dart';
import 'services/recommender.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _selectedIndex = 0;
  final PageStorageBucket _bucket = PageStorageBucket();
  final ClothingRecommender _recommender = ClothingRecommender();
  Map<String, String> _currentOutfit = {
    'top': 'No recommendation',
    'bottom': 'No recommendation'
  };
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final double _shakeThreshold = 15.0;
  DateTime? _lastShakeTime;

  @override
  void initState() {
    super.initState();
    _updateRecommendation();
    _requestSensorPermission();
  }

  Future<void> _requestSensorPermission() async {
    final status = await Permission.sensors.request();
    if (status.isGranted) {
      _startAccelerometer();
    }
  }

  void _startAccelerometer() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      if (_selectedIndex != 1) return; // 只在Home页检测

      final acceleration = Vector3(event.x, event.y, event.z).length;
      final now = DateTime.now();

      if (acceleration > _shakeThreshold) {
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!).inMilliseconds > 1000) {
          _lastShakeTime = now;
          _handleShake();
        }
      }
    });
  }

  void _handleShake() {
    // 强制刷新整个页面
    setState(() {
      _selectedIndex = 1; // 确保在 Home 页面
      _updateRecommendation(); // 更新推荐
    });

    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("✨ The new combination has been refreshed!"),
      duration: Duration(seconds: 1),
    ));
  }

  void _updateRecommendation() {
    final appState = context.read<ApplicationState>();
    final tempRange = appState.temperatureRange;

    try {
      if (tempRange.contains('°C ~ ')) {
        final tempValues = tempRange.split('°C ~ ');
        final dayMin = double.tryParse(tempValues[0]) ?? 0.0;
        final dayMax =
            double.tryParse(tempValues[1].replaceAll('°C', '')) ?? 0.0;

        setState(() {
          if (dayMax > 30) {
            _currentOutfit = {'top': 'short T-shirt', 'bottom': 'shorts'};
          } else if (dayMin < -10) {
            _currentOutfit = {'top': 'down jacket', 'bottom': 'down pants'};
          } else {
            _currentOutfit = _recommender.recommend(dayMin, dayMax);
          }
          print('The combination after mandatory update: $_currentOutfit');
        });
      }
    } catch (e) {
      print('Temperature parsing error: $e');
    }
  }

  void _updateTemperatureRange(String range) {
    context.read<ApplicationState>().updateTemperatureRange(range);
    _updateRecommendation();
  }

  late final List<Widget> _screens = [
    WeatherScreen(
      key: const PageStorageKey('weather'),
      onTemperatureRangeUpdate: _updateTemperatureRange,
    ),
    const HomeContent(key: PageStorageKey('home')),
    const HistoryScreen(key: PageStorageKey('history')),
  ];

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Weatherfit'),
        actions: [
          Consumer<ApplicationState>(
            builder: (context, appState, _) => IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _showLogoutConfirmation(context),
            ),
          ),
        ],
      ),
      body: PageStorage(
        bucket: _bucket,
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reminder'),
          content: const Text(
              'Are you sure you want to log out of the current account?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Sure'),
              onPressed: () {
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
                context.go('/');
              },
            ),
          ],
        );
      },
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final firstScreenState =
        context.findAncestorStateOfType<_FirstScreenState>()!;
    final appState = context.watch<ApplicationState>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        // 添加滚动支持
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's recommendation:",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.deepPurple[800],
                fontFamily: 'PlaywriteAUSA',
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'Temperature range: ${appState.temperatureRange}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            _buildRecommendationCard(
              "👕 Top",
              firstScreenState._currentOutfit['top'] ?? 'No recommendation',
              _getClothingImage(
                  firstScreenState._currentOutfit['top'] ?? 'T-shirt'),
            ),
            const SizedBox(height: 20),
            _buildRecommendationCard(
              "👖 Bottoms",
              firstScreenState._currentOutfit['bottom'] ?? 'No recommendation',
              _getClothingImage(
                  firstScreenState._currentOutfit['bottom'] ?? 'jeans'),
            ),
            
            
          ],
        ),

      ),
    );
  }

  Widget _buildRecommendationCard(
      String title, String recommendation, String imagePath) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 20)),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: Text(
                        recommendation,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      imagePath,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, size: 50);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getClothingImage(String clothingName) {
    // 根据服装名称返回对应的图片路径
    final Map<String, String> imageMap = {
      'short T-shirt': 'assets/clothes/short T.png',
      'T-shirt': 'assets/clothes/T-shirt.jpg',
      'sweater': 'assets/clothes/sweater.jpg',
      'knitwear': 'assets/clothes/knitwear.jpg',
      'hoodies': 'assets/clothes/hoodies.jpg',
      'wool sweater': 'assets/clothes/wool sweater.jpg',
      'suit jacket': 'assets/clothes/suit jacket.jpg',
      'jean jacket': 'assets/clothes/jean jacket.png',
      'light down jacket': 'assets/clothes/light down jacket.png',
      'down jacket': 'assets/clothes/down jacket.jpg',
      'jeans': 'assets/clothes/jeans.jpg',
      'trousers': 'assets/clothes/trousers.jpg',
      'cotton-wadded trousers': 'assets/clothes/cotton-wadded trousers.jpg',
      'fleece pants': 'assets/clothes/fleece pants.jpg',
      'down pants': 'assets/clothes/down pants.png',
      'shorts': 'assets/clothes/shorts.png',
    };

    return imageMap[clothingName] ??
        'assets/clothes/T-shirt.jpg'; // default image
  }
}
