import 'package:campuscare_app/features/repair_request/data/models/repair_priority.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RepairPriority', () {
    test('fromJson parses api value', () {
      expect(RepairPriority.fromJson('LOW'), RepairPriority.low);

      expect(RepairPriority.fromJson('MEDIUM'), RepairPriority.medium);

      expect(RepairPriority.fromJson('HIGH'), RepairPriority.high);
    });

    test('toJson returns api value', () {
      expect(RepairPriority.low.toJson(), 'LOW');

      expect(RepairPriority.medium.toJson(), 'MEDIUM');

      expect(RepairPriority.high.toJson(), 'HIGH');
    });

    test('throws FormatException for invalid value', () {
      expect(() => RepairPriority.fromJson('UNKNOWN'), throwsFormatException);
    });
  });
}
