import 'repair_request.dart';

class RepairRequestDetailResponse {
  const RepairRequestDetailResponse({
    required this.message,
    required this.repairRequest,
  });

  final String message;
  final RepairRequest repairRequest;

  factory RepairRequestDetailResponse.fromJson(Map<String, dynamic> json) {
    return RepairRequestDetailResponse(
      message: json['message'] as String,
      repairRequest: RepairRequest.fromJson(
        json['data']['repairRequest'] as Map<String, dynamic>,
      ),
    );
  }
}
