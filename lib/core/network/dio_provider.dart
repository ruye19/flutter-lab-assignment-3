import 'package:dio/dio.dart';

class DioProvider {
  static Dio createDio() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    return dio;
  }
}
