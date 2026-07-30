import '../../data/models/repair_request.dart';
import '../../data/models/repair_request_list_response.dart';

class RepairRequestListState {
  const RepairRequestListState({
    this.repairRequests = const [],
    this.pagination,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  final List<RepairRequest> repairRequests;
  final RepairRequestPagination? pagination;
  final bool isLoadingMore;
  final String? errorMessage;

  bool get isEmpty => repairRequests.isEmpty;

  bool get hasNextPage {
    final currentPagination = pagination;

    if (currentPagination == null) {
      return false;
    }

    return currentPagination.page < currentPagination.totalPages;
  }

  RepairRequestListState copyWith({
    List<RepairRequest>? repairRequests,
    RepairRequestPagination? pagination,
    bool clearPagination = false,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RepairRequestListState(
      repairRequests: repairRequests ?? this.repairRequests,
      pagination: clearPagination ? null : (pagination ?? this.pagination),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
