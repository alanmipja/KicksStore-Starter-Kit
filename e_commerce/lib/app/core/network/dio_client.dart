import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'dio_exception.dart';

class DioClient {
  DioClient({Dio? dio}) : _dio = dio ?? Dio() {
    _configureOptions();
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: false,
        ),
      );
    }
  }

  final Dio _dio;

  void _configureOptions() {
    _dio.options = BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(() => _dio.get<T>(path, queryParameters: queryParameters));
  }

  Future<Response<T>> _request<T>(
    Future<Response<T>> Function() requestCall,
  ) async {
    try {
      return await requestCall();
    } catch (error) {
      throw ErrorHandler.handle(error);
    }
  }
}
