import 'package:campuscare_app/features/auth/data/login_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses valid login response', () {
    final response = LoginResponse.fromJson({
      'success': true,
      'message': 'Đăng nhập thành công',
      'data': {
        'accessToken': 'sample-access-token',
        'tokenType': 'Bearer',
        'expiresIn': '7d',
        'user': {
          'id': 1,
          'username': 'student01',
          'fullName': 'Nguyễn Văn Sinh Viên',
          'studentCode': '2280600001',
          'role': 'USER',
        },
      },
    });

    expect(response.accessToken, 'sample-access-token');
    expect(response.tokenType, 'Bearer');
    expect(response.expiresIn, '7d');

    expect(response.user.id, 1);
    expect(response.user.username, 'student01');
    expect(response.user.fullName, 'Nguyễn Văn Sinh Viên');
    expect(response.user.studentCode, '2280600001');
    expect(response.user.role, 'USER');
  });

  test('throws FormatException when data is missing', () {
    expect(
      () => LoginResponse.fromJson({
        'success': true,
        'message': 'Đăng nhập thành công',
      }),
      throwsFormatException,
    );
  });

  test('throws FormatException when access token is missing', () {
    expect(
      () => LoginResponse.fromJson({
        'data': {
          'tokenType': 'Bearer',
          'expiresIn': '7d',
          'user': {
            'id': 1,
            'username': 'student01',
            'fullName': 'Nguyễn Văn Sinh Viên',
            'studentCode': '2280600001',
            'role': 'USER',
          },
        },
      }),
      throwsFormatException,
    );
  });
}
