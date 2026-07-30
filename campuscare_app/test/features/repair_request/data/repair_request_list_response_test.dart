import 'package:campuscare_app/features/repair_request/data/models/repair_category.dart';
import 'package:campuscare_app/features/repair_request/data/models/repair_priority.dart';
import 'package:campuscare_app/features/repair_request/data/models/repair_request_list_response.dart';
import 'package:campuscare_app/features/repair_request/data/models/repair_request_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RepairRequestListResponse', () {
    test('parses repair requests and pagination', () {
      final response = RepairRequestListResponse.fromJson({
        'success': true,
        'message': 'Lấy danh sách yêu cầu sửa chữa thành công',
        'data': {
          'repairRequests': [
            {
              'id': 1,
              'title': 'Máy lạnh không hoạt động',
              'description': 'Máy lạnh không thể khởi động',
              'category': 'AIR_CONDITIONER',
              'priority': 'HIGH',
              'campus': 'Ung Văn Khiêm',
              'location': 'Phòng A-01.05',
              'imageUrl': null,
              'status': 'PENDING',
              'managerNote': null,
              'createdAt': '2026-07-30T06:00:00.000Z',
              'updatedAt': '2026-07-30T06:00:00.000Z',
              'creator': {
                'id': 1,
                'username': 'student01',
                'fullName': 'Nguyễn Văn A',
                'studentCode': '2180600001',
                'role': 'USER',
              },
            },
          ],
          'pagination': {
            'page': 1,
            'pageSize': 10,
            'totalItems': 1,
            'totalPages': 1,
          },
        },
      });

      expect(response.repairRequests, hasLength(1));

      final repairRequest = response.repairRequests.first;

      expect(repairRequest.id, 1);
      expect(repairRequest.category, RepairCategory.airConditioner);
      expect(repairRequest.priority, RepairPriority.high);
      expect(repairRequest.status, RepairRequestStatus.pending);

      expect(response.pagination.page, 1);
      expect(response.pagination.pageSize, 10);
      expect(response.pagination.totalItems, 1);
      expect(response.pagination.totalPages, 1);
    });

    test('parses empty repair request list', () {
      final response = RepairRequestListResponse.fromJson({
        'success': true,
        'message': 'Lấy danh sách yêu cầu sửa chữa thành công',
        'data': {
          'repairRequests': <Map<String, dynamic>>[],
          'pagination': {
            'page': 1,
            'pageSize': 10,
            'totalItems': 0,
            'totalPages': 0,
          },
        },
      });

      expect(response.repairRequests, isEmpty);
      expect(response.pagination.totalItems, 0);
      expect(response.pagination.totalPages, 0);
    });
  });
}
