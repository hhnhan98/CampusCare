import 'package:campuscare_app/features/repair_request/data/models/repair_request_list_response.dart';
import 'package:campuscare_app/features/repair_request/presentation/states/repair_request_list_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RepairRequestListState', () {
    test('initial state', () {
      const state = RepairRequestListState();

      expect(state.repairRequests, isEmpty);
      expect(state.pagination, isNull);
      expect(state.isLoadingMore, isFalse);
      expect(state.errorMessage, isNull);
      expect(state.isEmpty, isTrue);
      expect(state.hasNextPage, isFalse);
    });

    test('hasNextPage returns true when another page exists', () {
      const state = RepairRequestListState(
        pagination: RepairRequestPagination(
          page: 1,
          pageSize: 10,
          totalItems: 15,
          totalPages: 2,
        ),
      );

      expect(state.hasNextPage, isTrue);
    });

    test('hasNextPage returns false on last page', () {
      const state = RepairRequestListState(
        pagination: RepairRequestPagination(
          page: 2,
          pageSize: 10,
          totalItems: 15,
          totalPages: 2,
        ),
      );

      expect(state.hasNextPage, isFalse);
    });

    test('copyWith updates loading and error', () {
      const state = RepairRequestListState();

      final next = state.copyWith(
        isLoadingMore: true,
        errorMessage: 'Không thể tải danh sách',
      );

      expect(next.isLoadingMore, isTrue);
      expect(next.errorMessage, 'Không thể tải danh sách');
    });

    test('copyWith clears error and pagination', () {
      const state = RepairRequestListState(
        pagination: RepairRequestPagination(
          page: 1,
          pageSize: 10,
          totalItems: 1,
          totalPages: 1,
        ),
        errorMessage: 'Lỗi',
      );

      final next = state.copyWith(clearError: true, clearPagination: true);

      expect(next.errorMessage, isNull);
      expect(next.pagination, isNull);
    });
  });
}
