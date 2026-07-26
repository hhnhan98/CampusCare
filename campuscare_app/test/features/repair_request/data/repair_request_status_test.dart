import 'package:flutter_test/flutter_test.dart';
import 'package:campuscare_app/features/repair_request/data/models/repair_request_status.dart';

void main() {
  group('RepairRequestStatus', () {
    test('fromJson parses api value', () {
      expect(
        RepairRequestStatus.fromJson('PENDING'),
        RepairRequestStatus.pending,
      );

      expect(
        RepairRequestStatus.fromJson('IN_PROGRESS'),
        RepairRequestStatus.inProgress,
      );

      expect(
        RepairRequestStatus.fromJson('COMPLETED'),
        RepairRequestStatus.completed,
      );
    });

    test('toJson returns api value', () {
      expect(RepairRequestStatus.pending.toJson(), 'PENDING');

      expect(RepairRequestStatus.inProgress.toJson(), 'IN_PROGRESS');

      expect(RepairRequestStatus.completed.toJson(), 'COMPLETED');
    });

    test('throws FormatException for invalid value', () {
      expect(
        () => RepairRequestStatus.fromJson('UNKNOWN'),
        throwsFormatException,
      );
    });
  });
}
