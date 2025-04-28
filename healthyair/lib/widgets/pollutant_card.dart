import 'package:flutter/material.dart';
import '../models/air_quality_data.dart';

class PollutantCard extends StatelessWidget {
  final PollutantData pollutant;
  final bool isDominant;

  const PollutantCard({
    Key? key,
    required this.pollutant,
    this.isDominant = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: isDominant
            ? BorderSide(color: pollutant.getColor(), width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          _showPollutantInfo(context);
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Pollutant indicator color
              Container(
                width: 16,
                height: 60,
                decoration: BoxDecoration(
                  color: pollutant.getColor(),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),
              
              // Pollutant information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          pollutant.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isDominant)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: pollutant.getColor().withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Dominant Pollutant',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to view health advice',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Pollutant value
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    pollutant.value.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: pollutant.getColor(),
                    ),
                  ),
                  Text(
                    pollutant.unit,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showPollutantInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: pollutant.getColor(),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text('${pollutant.name} Health Advice'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Current Value: ${pollutant.value.toStringAsFixed(1)} ${pollutant.unit}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: pollutant.getColor(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Health Tips:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(pollutant.getHealthRecommendation()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(
                context,
                '/pollutant-details',
                arguments: pollutant.name,
              );
            },
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }
}