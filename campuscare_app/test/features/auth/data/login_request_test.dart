import 'package:campuscare_app/features/auth/data/login_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converts login request to expected JSON', () {
    const request = LoginRequest(username: '  student01  ', password: '123456');

    expect(request.toJson(), {'username': 'student01', 'password': '123456'});
  });

  test('does not trim password', () {
    const request = LoginRequest(username: 'student01', password: ' 123456 ');

    expect(request.toJson()['password'], ' 123456 ');
  });
}
