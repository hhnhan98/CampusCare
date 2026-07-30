import 'package:campuscare_app/features/repair_request/presentation/states/update_repair_request_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UpdateRepairRequestState', () {
    test('initial state', () {
      const state = UpdateRepairRequestState();

      expect(state.status, UpdateRepairRequestStatus.initial);
      expect(state.repairRequest, isNull);
      expect(state.errorMessage, isNull);
      expect(state.isLoading, isFalse);
      expect(state.isSuccess, isFalse);
    });

    test('loading state', () {
      const state = UpdateRepairRequestState(
        status: UpdateRepairRequestStatus.loading,
      );

      expect(state.isLoading, isTrue);
      expect(state.isSuccess, isFalse);
    });

    test('success state', () {
      const state = UpdateRepairRequestState(
        status: UpdateRepairRequestStatus.success,
      );

      expect(state.isLoading, isFalse);
      expect(state.isSuccess, isTrue);
    });

    test('copyWith updates status and error', () {
      const state = UpdateRepairRequestState();

      final next = state.copyWith(
        status: UpdateRepairRequestStatus.failure,
        errorMessage: 'Không thể cập nhật yêu cầu',
      );

      expect(next.status, UpdateRepairRequestStatus.failure);
      expect(next.errorMessage, 'Không thể cập nhật yêu cầu');
    });

    test('copyWith clears error', () {
      const state = UpdateRepairRequestState(
        status: UpdateRepairRequestStatus.failure,
        errorMessage: 'Lỗi',
      );

      final next = state.copyWith(
        status: UpdateRepairRequestStatus.initial,
        clearError: true,
      );

      expect(next.status, UpdateRepairRequestStatus.initial);
      expect(next.errorMessage, isNull);
    });
  });
}
