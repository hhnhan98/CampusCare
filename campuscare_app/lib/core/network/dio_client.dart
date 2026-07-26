import 'package:dio/dio.dart';

import 'api_constants.dart';

abstract final class DioClient {
  static Dio create() {
    return Dio(
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
  }

  DioClient._();
}
