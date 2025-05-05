import 'dart:math';
import '../data/wardrobe.dart';

class ClothingRecommender {
  final Random _random = Random();

  Map<String, String> recommend(double dayMin, double dayMax) {
    // Handling of extreme temperature conditions
    if (dayMax > 30) {
      return _summerOutfit();
    }
    if (dayMin < -10) {
      return _winterOutfit();
    }

    // Normal recommendation logic
    return {
      'top': _pickClothing(dayMin, dayMax, isTop: true),
      'bottom': _pickClothing(dayMin, dayMax, isTop: false),
    };
  }

  String _pickClothing(double dayMin, double dayMax, {required bool isTop}) {
    final candidates = wardrobe.where((item) {
      return item.isTop == isTop && item.matchesRange(dayMin, dayMax);
    }).toList();

    if (candidates.isEmpty) {
      return isTop ? "No suitable top" : "No suitable bottom";
    }

    return candidates[_random.nextInt(candidates.length)].name;
  }

  // Summer fixed matching
  Map<String, String> _summerOutfit() {
    return {
      'top': "short T-shirt",
      'bottom': "shorts",
    };
  }

  // Winter fixed matching
  Map<String, String> _winterOutfit() {
    return {
      'top': "down jacket",
      'bottom': "down pants",
    };
  }
}