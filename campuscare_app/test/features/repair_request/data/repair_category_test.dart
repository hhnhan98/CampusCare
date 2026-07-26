import 'package:campuscare_app/features/repair_request/data/models/repair_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RepairCategory', () {
    test('fromJson parses api value', () {
      expect(RepairCategory.fromJson('ELECTRICAL'), RepairCategory.electrical);

      expect(RepairCategory.fromJson('WATER'), RepairCategory.water);

      expect(
        RepairCategory.fromJson('AIR_CONDITIONER'),
        RepairCategory.airConditioner,
      );

      expect(RepairCategory.fromJson('INTERNET'), RepairCategory.internet);

      expect(RepairCategory.fromJson('FURNITURE'), RepairCategory.furniture);

      expect(RepairCategory.fromJson('OTHER'), RepairCategory.other);
    });

    test('toJson returns api value', () {
      expect(RepairCategory.electrical.toJson(), 'ELECTRICAL');

      expect(RepairCategory.water.toJson(), 'WATER');

      expect(RepairCategory.airConditioner.toJson(), 'AIR_CONDITIONER');

      expect(RepairCategory.internet.toJson(), 'INTERNET');

      expect(RepairCategory.furniture.toJson(), 'FURNITURE');

      expect(RepairCategory.other.toJson(), 'OTHER');
    });

    test('throws FormatException for invalid value', () {
      expect(() => RepairCategory.fromJson('ABC'), throwsFormatException);
    });
  });
}
