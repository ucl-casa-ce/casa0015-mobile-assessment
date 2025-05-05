import 'package:flutter_test/flutter_test.dart';
import '../lib/services/recommender.dart';

void main() {
  final recommender = ClothingRecommender();

  group('Clothing recommendation test', () {
    test('There should be multiple options for the recommended temperature range of 18-22°C', () {
      final result = recommender.recommend(18, 22);
      
      // Verify the possibility of the coat
      expect(
        ["short T-shirt","T-shirt", "knitwear", "hoodies", "suit jacket", "jean jacket"],
        contains(result['top'])
      );
      
      // Verify the possibility of the pants
      expect(
        ["trousers", "jeans"],
        contains(result['bottom'])
      );
    });

    test('25°C triggers summer mode', () {
      final result = recommender.recommend(30, 35);
      expect(result['top'], "short T-shirt");
      expect(result['bottom'], "shorts");
    });

    test('-10°C triggers winter mode', () {
      final result = recommender.recommend(-10, -8);
      expect(result['top'], "down jacket");
      expect(result['bottom'], "down pants");
    });
  });
}