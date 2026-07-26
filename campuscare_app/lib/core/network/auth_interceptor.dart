import 'package:dio/dio.dart';

import '../../features/auth/data/auth_token_storage.dart';
import 'api_constants.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final AuthTokenStorage _tokenStorage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = _tokenStorage.readAccessToken();

    if (accessToken != null) {
      options.headers[ApiConstants.authorizationHeader] = 'Bearer $accessToken';
    }

    handler.next(options);
  }
}
