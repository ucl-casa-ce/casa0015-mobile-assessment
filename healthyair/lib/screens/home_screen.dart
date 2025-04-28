import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../providers/air_quality_provider.dart';
import '../widgets/pollutant_card.dart';
import '../widgets/aqi_summary_widget.dart';
import '../models/air_quality_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _lastX = 0, _lastY = 0, _lastZ = 0;
  int _shakeCount = 0;
  final int _shakeThreshold = 3; // Lower sensitivity threshold

  @override
  void initState() {
    super.initState();
    // Ensure we have data
    final provider = Provider.of<AirQualityProvider>(context, listen: false);
    if (provider.airQualityData == null) {
      provider.initializeLocationAndData();
    }

    // Listen to accelerometer events
    accelerometerEvents.listen((event) {
      final double deltaX = (event.x - _lastX).abs();
      final double deltaY = (event.y - _lastY).abs();
      final double deltaZ = (event.z - _lastZ).abs();

      // Detect if acceleration changes exceed the threshold
      if (deltaX > _shakeThreshold || deltaY > _shakeThreshold || deltaZ > _shakeThreshold) {
        _shakeCount++;

        if (_shakeCount >= 2) { // Reset shake count after detecting two shakes
          _shakeCount = 0; // Reset shake count
          Provider.of<AirQualityProvider>(context, listen: false).refreshData();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Shake detected! Refreshing data...')),
          );
        }
      }

      // Update the last acceleration values
      _lastX = event.x;
      _lastY = event.y;
      _lastZ = event.z;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.air,
              color: Colors.white, // Change to pure white
              size: 32, // Increase icon size
            ),
            const SizedBox(width: 8),
            Text(
              'Enjoy Healthy Air',
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                color: Colors.white, 
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<AirQualityProvider>(context, listen: false).refreshData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              Provider.of<AirQualityProvider>(context, listen: false).initializeLocationAndData();
            },
            tooltip: 'Back to Current Location',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<AirQualityProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading data',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(provider.error ?? 'Unknown error'),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => provider.refreshData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            if (provider.airQualityData == null) {
              return const Center(child: Text('No data available'));
            }
            
            final airQualityData = provider.airQualityData!;
            
            return RefreshIndicator(
              onRefresh: provider.refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // City and update time information
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 18, color: Colors.blue),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        provider.formattedCity.isNotEmpty ? provider.formattedCity : 'Unknown City',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis, // Prevent overflow
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Last updated: ${airQualityData.time}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis, // Prevent overflow
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // AQI summary widget
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AQISummaryWidget(airQualityData: airQualityData),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Section title for pollutants
                      Text(
                        'Key Pollutants',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Pollutant cards
                      if (airQualityData.pollutants.isEmpty)
                        const Center(
                          child: Text(
                            'No pollutant data available',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: airQualityData.pollutants.length,
                          itemBuilder: (context, index) {
                            final pollutantKey = airQualityData.pollutants.keys.elementAt(index);
                            final pollutant = airQualityData.pollutants[pollutantKey]!;
                            
                            // Check if this is the dominant pollutant
                            bool isDominant = pollutantKey == airQualityData.dominantPollutant;
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: PollutantCard(
                                pollutant: pollutant,
                                isDominant: isDominant,
                              ),
                            );
                          },
                        ),
                      
                      const SizedBox(height: 24),
                      
                      // Navigation to detailed information
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.info_outline),
                          label: const Text('View Pollutant Health Info'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/pollutant-details');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}