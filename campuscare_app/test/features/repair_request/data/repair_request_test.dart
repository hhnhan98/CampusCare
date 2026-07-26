import 'package:campuscare_app/features/repair_request/data/models/repair_category.dart';
import 'package:campuscare_app/features/repair_request/data/models/repair_priority.dart';
import 'package:campuscare_app/features/repair_request/data/models/repair_request.dart';
import 'package:campuscare_app/features/repair_request/data/models/repair_request_creator.dart';
import 'package:campuscare_app/features/repair_request/data/models/repair_request_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RepairRequest', () {
    test('fromJson parses all fields correctly', () {
      final json = <String, dynamic>{
        'id': 101,
        'title': 'Máy lạnh không hoạt động',
        'description': 'Máy lạnh tại phòng A-01 không thể khởi động.',
        'category': 'AIR_CONDITIONER',
        'priority': 'HIGH',
        'campus': 'Thu Duc Campus',
        'location': 'A-01.02',
        'imageUrl': 'https://example.com/images/repair-101.jpg',
        'status': 'IN_PROGRESS',
        'managerNote': 'Đã chuyển yêu cầu cho bộ phận kỹ thuật.',
        'createdAt': '2026-07-27T08:30:00.000Z',
        'updatedAt': '2026-07-27T09:45:00.000Z',
        'creator': <String, dynamic>{
          'id': 1,
          'username': 'student01',
          'fullName': 'Hồ Hoàng Nhân',
          'studentCode': '2280601234',
          'role': 'USER',
        },
      };

      final repairRequest = RepairRequest.fromJson(json);

      expect(repairRequest.id, 101);
      expect(repairRequest.title, 'Máy lạnh không hoạt động');
      expect(
        repairRequest.description,
        'Máy lạnh tại phòng A-01 không thể khởi động.',
      );
      expect(repairRequest.category, RepairCategory.airConditioner);
      expect(repairRequest.priority, RepairPriority.high);
      expect(repairRequest.campus, 'Thu Duc Campus');
      expect(repairRequest.location, 'A-01.02');
      expect(
        repairRequest.imageUrl,
        'https://example.com/images/repair-101.jpg',
      );
      expect(repairRequest.status, RepairRequestStatus.inProgress);
      expect(
        repairRequest.managerNote,
        'Đã chuyển yêu cầu cho bộ phận kỹ thuật.',
      );
      expect(
        repairRequest.createdAt,
        DateTime.parse('2026-07-27T08:30:00.000Z'),
      );
      expect(
        repairRequest.updatedAt,
        DateTime.parse('2026-07-27T09:45:00.000Z'),
      );

      expect(repairRequest.creator.id, 1);
      expect(repairRequest.creator.username, 'student01');
      expect(repairRequest.creator.fullName, 'Hồ Hoàng Nhân');
      expect(repairRequest.creator.studentCode, '2280601234');
      expect(repairRequest.creator.role, 'USER');
    });

    test('fromJson accepts nullable fields', () {
      final json = <String, dynamic>{
        'id': 102,
        'title': 'Bàn học bị hỏng',
        'description': 'Chân bàn bị lỏng.',
        'category': 'FURNITURE',
        'priority': 'LOW',
        'campus': 'Sai Gon Campus',
        'location': 'B-03.01',
        'imageUrl': null,
        'status': 'PENDING',
        'managerNote': null,
        'createdAt': '2026-07-27T10:00:00.000Z',
        'updatedAt': '2026-07-27T10:00:00.000Z',
        'creator': <String, dynamic>{
          'id': 2,
          'username': 'student02',
          'fullName': 'Nguyễn Minh An',
          'studentCode': null,
          'role': 'USER',
        },
      };

      final repairRequest = RepairRequest.fromJson(json);

      expect(repairRequest.imageUrl, isNull);
      expect(repairRequest.managerNote, isNull);
      expect(repairRequest.creator.studentCode, isNull);
    });

    test('toJson returns all fields correctly', () {
      final repairRequest = RepairRequest(
        id: 103,
        title: 'Mất kết nối Internet',
        description: 'Wi-Fi tại thư viện không truy cập được.',
        category: RepairCategory.internet,
        priority: RepairPriority.medium,
        campus: 'Thu Duc Campus',
        location: 'Library - Floor 2',
        imageUrl: 'https://example.com/images/repair-103.jpg',
        status: RepairRequestStatus.completed,
        managerNote: 'Đã khởi động lại thiết bị mạng.',
        createdAt: DateTime.parse('2026-07-27T11:15:00.000Z'),
        updatedAt: DateTime.parse('2026-07-27T12:30:00.000Z'),
        creator: const RepairRequestCreator(
          id: 3,
          username: 'student03',
          fullName: 'Trần Gia Hân',
          studentCode: '2280605678',
          role: 'USER',
        ),
      );

      expect(repairRequest.toJson(), <String, dynamic>{
        'id': 103,
        'title': 'Mất kết nối Internet',
        'description': 'Wi-Fi tại thư viện không truy cập được.',
        'category': 'INTERNET',
        'priority': 'MEDIUM',
        'campus': 'Thu Duc Campus',
        'location': 'Library - Floor 2',
        'imageUrl': 'https://example.com/images/repair-103.jpg',
        'status': 'COMPLETED',
        'managerNote': 'Đã khởi động lại thiết bị mạng.',
        'createdAt': '2026-07-27T11:15:00.000Z',
        'updatedAt': '2026-07-27T12:30:00.000Z',
        'creator': <String, dynamic>{
          'id': 3,
          'username': 'student03',
          'fullName': 'Trần Gia Hân',
          'studentCode': '2280605678',
          'role': 'USER',
        },
      });
    });

    test('fromJson throws FormatException for invalid category', () {
      final json = <String, dynamic>{
        'id': 104,
        'title': 'Thiết bị hỏng',
        'description': 'Mô tả lỗi thiết bị.',
        'category': 'UNKNOWN_CATEGORY',
        'priority': 'LOW',
        'campus': 'Thu Duc Campus',
        'location': 'C-01.01',
        'imageUrl': null,
        'status': 'PENDING',
        'managerNote': null,
        'createdAt': '2026-07-27T13:00:00.000Z',
        'updatedAt': '2026-07-27T13:00:00.000Z',
        'creator': <String, dynamic>{
          'id': 4,
          'username': 'student04',
          'fullName': 'Lê Minh Khoa',
          'studentCode': '2280609999',
          'role': 'USER',
        },
      };

      expect(() => RepairRequest.fromJson(json), throwsFormatException);
    });

    test('fromJson throws FormatException for invalid date', () {
      final json = <String, dynamic>{
        'id': 105,
        'title': 'Rò rỉ nước',
        'description': 'Ống nước bị rò rỉ.',
        'category': 'WATER',
        'priority': 'HIGH',
        'campus': 'Thu Duc Campus',
        'location': 'D-02.03',
        'imageUrl': null,
        'status': 'PENDING',
        'managerNote': null,
        'createdAt': 'invalid-date',
        'updatedAt': '2026-07-27T14:00:00.000Z',
        'creator': <String, dynamic>{
          'id': 5,
          'username': 'student05',
          'fullName': 'Phạm Ngọc Mai',
          'studentCode': '2280608888',
          'role': 'USER',
        },
      };

      expect(() => RepairRequest.fromJson(json), throwsFormatException);
    });
  });
}
