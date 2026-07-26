import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../models/repair_category.dart';
import '../models/repair_priority.dart';
import '../models/repair_request_detail_response.dart';
import '../models/repair_request_list_response.dart';
import '../models/repair_request_status.dart';
import '../services/repair_request_api_service.dart';

class RepairRequestRepository {
  const RepairRequestRepository({required RepairRequestApiService apiService})
    : _apiService = apiService;

  final RepairRequestApiService _apiService;

  Future<RepairRequestListResponse> getRepairRequests({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _apiService.getRepairRequests(
        queryParameters: queryParameters,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<RepairRequestDetailResponse> getRepairRequestById(int id) async {
    try {
      return await _apiService.getRepairRequestById(id);
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<RepairRequestDetailResponse> createRepairRequest({
    required String title,
    required String description,
    required RepairCategory category,
    required RepairPriority priority,
    required String campus,
    required String location,
    String? imagePath,
  }) async {
    try {
      return await _apiService.createRepairRequest(
        title: title,
        description: description,
        category: category,
        priority: priority,
        campus: campus,
        location: location,
        imagePath: imagePath,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }

  Future<RepairRequestDetailResponse> updateRepairRequestStatus({
    required int id,
    required RepairRequestStatus status,
    String? managerNote,
  }) async {
    try {
      return await _apiService.updateRepairRequestStatus(
        id: id,
        status: status,
        managerNote: managerNote,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
