import 'package:campuscare_app/features/repair_request/presentation/states/create_repair_request_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreateRepairRequestState', () {
    test('initial state', () {
      const state = CreateRepairRequestState();

      expect(state.status, CreateRepairRequestStatus.initial);
      expect(state.errorMessage, isNull);
      expect(state.isLoading, isFalse);
      expect(state.isSuccess, isFalse);
    });

    test('loading state', () {
      const state = CreateRepairRequestState(
        status: CreateRepairRequestStatus.loading,
      );

      expect(state.isLoading, isTrue);
      expect(state.isSuccess, isFalse);
    });

    test('success state', () {
      const state = CreateRepairRequestState(
        status: CreateRepairRequestStatus.success,
      );

      expect(state.isSuccess, isTrue);
      expect(state.isLoading, isFalse);
    });

    test('copyWith updates status', () {
      const state = CreateRepairRequestState();

      final next = state.copyWith(status: CreateRepairRequestStatus.loading);

      expect(next.status, CreateRepairRequestStatus.loading);
    });

    test('copyWith clears error', () {
      const state = CreateRepairRequestState(
        status: CreateRepairRequestStatus.failure,
        errorMessage: 'Không thể tạo yêu cầu',
      );

      final next = state.copyWith(clearError: true);

      expect(next.errorMessage, isNull);
    });
  });
}
