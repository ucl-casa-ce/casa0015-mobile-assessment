import 'package:flutter/material.dart';
import '../models/air_quality_data.dart';

class AQISummaryWidget extends StatelessWidget {
  final AirQualityData airQualityData;

  const AQISummaryWidget({
    Key? key,
    required this.airQualityData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: airQualityData.getAQIColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: airQualityData.getAQIColor(),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Air Quality Index (AQI)',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${airQualityData.aqi}',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: airQualityData.getAQIColor(),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: airQualityData.getAQIColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  airQualityData.getAQIStatus(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getAQIRecommendation(airQualityData.aqi),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _getAQIRecommendation(int aqi) {
    if (aqi <= 50) {
      return 'Air quality is satisfactory, with little or no risk to health. All groups can carry out normal activities.';
    } else if (aqi <= 100) {
      return 'Air quality is acceptable; however, some pollutants may pose a slight health concern for a very small number of sensitive individuals.';
    } else if (aqi <= 150) {
      return 'Light pollution: Sensitive groups may experience mild health effects, while the general public is unlikely to be affected.';
    } else if (aqi <= 200) {
      return 'Moderate pollution: Health effects may become more noticeable for sensitive groups, and some health effects may occur for the general public.';
    } else if (aqi <= 300) {
      return 'Heavy pollution: Reduced tolerance for physical activity, noticeable symptoms, and potential health effects for the general public.';
    } else {
      return 'Severe pollution: Strong health effects for everyone, with potential for serious health issues. Children, the elderly, and those with pre-existing conditions should stay indoors and avoid physical exertion.';
    }
  }
}