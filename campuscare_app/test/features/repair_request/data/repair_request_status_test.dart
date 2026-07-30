import 'package:campuscare_app/features/repair_request/data/models/repair_request_status.dart';
import 'package:flutter_test/flutter_test.dart';

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

    test('pending allows staying pending or moving to in progress', () {
      expect(RepairRequestStatus.pending.allowedUpdateStatuses, const [
        RepairRequestStatus.pending,
        RepairRequestStatus.inProgress,
      ]);

      expect(
        RepairRequestStatus.pending.canTransitionTo(
          RepairRequestStatus.pending,
        ),
        isTrue,
      );

      expect(
        RepairRequestStatus.pending.canTransitionTo(
          RepairRequestStatus.inProgress,
        ),
        isTrue,
      );

      expect(
        RepairRequestStatus.pending.canTransitionTo(
          RepairRequestStatus.completed,
        ),
        isFalse,
      );
    });

    test('in progress allows staying or moving to completed', () {
      expect(RepairRequestStatus.inProgress.allowedUpdateStatuses, const [
        RepairRequestStatus.inProgress,
        RepairRequestStatus.completed,
      ]);

      expect(
        RepairRequestStatus.inProgress.canTransitionTo(
          RepairRequestStatus.pending,
        ),
        isFalse,
      );

      expect(
        RepairRequestStatus.inProgress.canTransitionTo(
          RepairRequestStatus.inProgress,
        ),
        isTrue,
      );

      expect(
        RepairRequestStatus.inProgress.canTransitionTo(
          RepairRequestStatus.completed,
        ),
        isTrue,
      );
    });

    test('completed only allows staying completed', () {
      expect(RepairRequestStatus.completed.allowedUpdateStatuses, const [
        RepairRequestStatus.completed,
      ]);

      expect(
        RepairRequestStatus.completed.canTransitionTo(
          RepairRequestStatus.pending,
        ),
        isFalse,
      );

      expect(
        RepairRequestStatus.completed.canTransitionTo(
          RepairRequestStatus.inProgress,
        ),
        isFalse,
      );

      expect(
        RepairRequestStatus.completed.canTransitionTo(
          RepairRequestStatus.completed,
        ),
        isTrue,
      );
    });
  });
}
