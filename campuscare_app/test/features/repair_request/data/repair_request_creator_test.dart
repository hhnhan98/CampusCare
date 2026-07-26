import 'package:campuscare_app/features/repair_request/data/models/repair_request_creator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RepairRequestCreator', () {
    test('fromJson parses all fields correctly', () {
      final json = <String, dynamic>{
        'id': 1,
        'username': 'nhan.ho',
        'fullName': 'Hồ Hoàng Nhân',
        'studentCode': '2280601234',
        'role': 'USER',
      };

      final creator = RepairRequestCreator.fromJson(json);

      expect(creator.id, 1);
      expect(creator.username, 'nhan.ho');
      expect(creator.fullName, 'Hồ Hoàng Nhân');
      expect(creator.studentCode, '2280601234');
      expect(creator.role, 'USER');
    });

    test('fromJson accepts null studentCode', () {
      final json = <String, dynamic>{
        'id': 2,
        'username': 'manager01',
        'fullName': 'Nguyễn Văn Quản Lý',
        'studentCode': null,
        'role': 'MANAGER',
      };

      final creator = RepairRequestCreator.fromJson(json);

      expect(creator.id, 2);
      expect(creator.username, 'manager01');
      expect(creator.fullName, 'Nguyễn Văn Quản Lý');
      expect(creator.studentCode, isNull);
      expect(creator.role, 'MANAGER');
    });

    test('toJson returns all fields correctly', () {
      const creator = RepairRequestCreator(
        id: 3,
        username: 'student01',
        fullName: 'Trần Minh An',
        studentCode: '2280605678',
        role: 'USER',
      );

      expect(creator.toJson(), <String, dynamic>{
        'id': 3,
        'username': 'student01',
        'fullName': 'Trần Minh An',
        'studentCode': '2280605678',
        'role': 'USER',
      });
    });

    test('toJson includes null studentCode', () {
      const creator = RepairRequestCreator(
        id: 4,
        username: 'manager02',
        fullName: 'Lê Thị Mai',
        role: 'MANAGER',
      );

      expect(creator.toJson(), <String, dynamic>{
        'id': 4,
        'username': 'manager02',
        'fullName': 'Lê Thị Mai',
        'studentCode': null,
        'role': 'MANAGER',
      });
    });
  });
}
