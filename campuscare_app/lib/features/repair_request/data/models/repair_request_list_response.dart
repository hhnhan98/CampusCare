import 'repair_request.dart';

class RepairRequestListResponse {
  const RepairRequestListResponse({
    required this.repairRequests,
    required this.pagination,
  });

  final List<RepairRequest> repairRequests;
  final RepairRequestPagination pagination;

  factory RepairRequestListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final repairRequestsJson = data['repairRequests'] as List<dynamic>;

    return RepairRequestListResponse(
      repairRequests: repairRequestsJson
          .map((item) => RepairRequest.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: RepairRequestPagination.fromJson(
        data['pagination'] as Map<String, dynamic>,
      ),
    );
  }
}

class RepairRequestPagination {
  const RepairRequestPagination({
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  factory RepairRequestPagination.fromJson(Map<String, dynamic> json) {
    return RepairRequestPagination(
      page: json['page'] as int,
      pageSize: json['pageSize'] as int,
      totalItems: json['totalItems'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}
