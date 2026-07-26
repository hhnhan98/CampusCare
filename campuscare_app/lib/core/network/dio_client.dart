import 'package:dio/dio.dart';

import '../../features/auth/data/auth_token_storage.dart';
import 'api_constants.dart';
import 'auth_interceptor.dart';

abstract final class DioClient {
  static Dio create({required AuthTokenStorage tokenStorage}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: const {Headers.acceptHeader: Headers.jsonContentType},
      ),
    );

    dio.interceptors.add(AuthInterceptor(tokenStorage));

    return dio;
  }

  DioClient._();
}
