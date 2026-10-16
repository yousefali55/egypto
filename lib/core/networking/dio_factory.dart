import 'package:dio/dio.dart';
import 'package:egypto/core/networking/api_constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  DioFactory._();

  static Dio createDio() {
    final dio = _createBaseDio();

    dio.interceptors.add(
      PrettyDioLogger(
        request: true,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
      ),
    );

    return dio;
  }

  static Dio createRefreshDio() {
    final dio = _createBaseDio();
    //ابقى امسح الترو منهم
    dio.interceptors.add(
      PrettyDioLogger(
        request: true,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
      ),
    );

    return dio;
  }

  static Dio _createBaseDio() {
    return Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );
  }
}
