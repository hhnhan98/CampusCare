import 'package:campuscare_app/features/auth/data/current_user_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrentUserResponse', () {
    test('parses current user response', () {
      final response = CurrentUserResponse.fromJson({
        'success': true,
        'message': 'Lấy thông tin người dùng thành công',
        'data': {
          'user': {
            'id': 2,
            'username': 'manager01',
            'fullName': 'Quản lý cơ sở vật chất',
            'studentCode': 'MANAGER01',
            'role': 'MANAGER',
          },
        },
      });

      expect(response.message, 'Lấy thông tin người dùng thành công');
      expect(response.user.id, 2);
      expect(response.user.username, 'manager01');
      expect(response.user.role, 'MANAGER');
    });

    test('throws when user data is missing', () {
      expect(
        () => CurrentUserResponse.fromJson({
          'success': true,
          'message': 'Lấy thông tin người dùng thành công',
          'data': <String, dynamic>{},
        }),
        throwsFormatException,
      );
    });
  });
}
