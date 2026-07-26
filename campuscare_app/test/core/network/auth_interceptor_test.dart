import 'package:campuscare_app/core/network/auth_interceptor.dart';
import 'package:campuscare_app/features/auth/data/auth_token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campuscare_app/core/network/api_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthInterceptor', () {
    late SharedPreferences preferences;
    late AuthTokenStorage tokenStorage;
    late AuthInterceptor interceptor;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});

      preferences = await SharedPreferences.getInstance();
      tokenStorage = AuthTokenStorage(preferences);
      interceptor = AuthInterceptor(tokenStorage);
    });

    test('adds Authorization header when access token exists', () async {
      await tokenStorage.saveAccessToken('sample-token');

      final options = RequestOptions(path: '/repair-requests');

      interceptor.onRequest(options, RequestInterceptorHandler());

      expect(
        options.headers[ApiConstants.authorizationHeader],
        'Bearer sample-token',
      );
    });

    test('does not add Authorization header when token is missing', () {
      final options = RequestOptions(path: '/auth/login');

      interceptor.onRequest(options, RequestInterceptorHandler());

      expect(
        options.headers.containsKey(ApiConstants.authorizationHeader),
        isFalse,
      );
    });
  });
}
