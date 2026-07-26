import 'package:dio/dio.dart';

import '../models/repair_category.dart';
import '../models/repair_priority.dart';
import '../models/repair_request_detail_response.dart';
import '../models/repair_request_list_response.dart';
import '../models/repair_request_status.dart';

class RepairRequestApiService {
  const RepairRequestApiService(this._dio);

  final Dio _dio;

  static const String _repairRequestsPath = '/repair-requests';

  Future<RepairRequestListResponse> getRepairRequests({
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _repairRequestsPath,
      queryParameters: queryParameters,
    );

    return RepairRequestListResponse.fromJson(_requireResponseData(response));
  }

  Future<RepairRequestDetailResponse> getRepairRequestById(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_repairRequestsPath/$id',
    );

    return RepairRequestDetailResponse.fromJson(_requireResponseData(response));
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
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      'category': category.toJson(),
      'priority': priority.toJson(),
      'campus': campus,
      'location': location,
      if (imagePath != null && imagePath.isNotEmpty)
        'image': await MultipartFile.fromFile(imagePath),
    });

    final response = await _dio.post<Map<String, dynamic>>(
      _repairRequestsPath,
      data: formData,
    );

    return RepairRequestDetailResponse.fromJson(_requireResponseData(response));
  }

  Future<RepairRequestDetailResponse> updateRepairRequestStatus({
    required int id,
    required RepairRequestStatus status,
    String? managerNote,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '$_repairRequestsPath/$id/status',
      data: {
        'status': status.toJson(),
        if (managerNote != null) 'managerNote': managerNote,
      },
    );

    return RepairRequestDetailResponse.fromJson(_requireResponseData(response));
  }

  Map<String, dynamic> _requireResponseData(
    Response<Map<String, dynamic>> response,
  ) {
    final data = response.data;

    if (data == null) {
      throw const FormatException('Phản hồi từ máy chủ không chứa dữ liệu');
    }

    return data;
  }
}
