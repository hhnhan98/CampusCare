import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/models/repair_request_list_response.dart';
import '../../providers/repair_request_providers.dart';
import '../states/repair_request_list_state.dart';

final repairRequestListControllerProvider =
    AsyncNotifierProvider<RepairRequestListController, RepairRequestListState>(
      RepairRequestListController.new,
    );

class RepairRequestListController
    extends AsyncNotifier<RepairRequestListState> {
  static const int _pageSize = 10;

  @override
  Future<RepairRequestListState> build() async {
    return _loadPage(page: 1);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _loadPage(page: 1));
  }

  Future<void> loadNextPage() async {
    final currentState = state.value;

    if (currentState == null ||
        currentState.isLoadingMore ||
        !currentState.hasNextPage) {
      return;
    }

    final currentPagination = currentState.pagination;

    if (currentPagination == null) {
      return;
    }

    state = AsyncData(
      currentState.copyWith(isLoadingMore: true, clearError: true),
    );

    try {
      final nextPage = currentPagination.page + 1;
      final response = await _getRepairRequests(page: nextPage);

      state = AsyncData(
        RepairRequestListState(
          repairRequests: [
            ...currentState.repairRequests,
            ...response.repairRequests,
          ],
          pagination: response.pagination,
        ),
      );
    } catch (error) {
      state = AsyncData(
        currentState.copyWith(
          isLoadingMore: false,
          errorMessage: _extractErrorMessage(error),
        ),
      );
    }
  }

  Future<RepairRequestListState> _loadPage({required int page}) async {
    try {
      final response = await _getRepairRequests(page: page);

      return RepairRequestListState(
        repairRequests: response.repairRequests,
        pagination: response.pagination,
      );
    } catch (error) {
      return RepairRequestListState(errorMessage: _extractErrorMessage(error));
    }
  }

  Future<RepairRequestListResponse> _getRepairRequests({required int page}) {
    final repository = ref.read(repairRequestRepositoryProvider);

    return repository.getRepairRequests(
      queryParameters: {'page': page, 'pageSize': _pageSize},
    );
  }

  String _extractErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return 'Không thể tải danh sách yêu cầu. Vui lòng thử lại.';
  }
}
