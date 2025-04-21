import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioHelper {
  static late Dio dio;

  // Initialize Dio with advanced configuration
  static void init({required String baseUrl, int timeoutSeconds = 30}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: timeoutSeconds),
        receiveTimeout: Duration(seconds: timeoutSeconds),
        responseType: ResponseType.json,
      ),
    );

    // Add interceptors for logging and error handling
    dio.interceptors.add(LogInterceptor(
      request: kDebugMode,
      requestBody: kDebugMode,
      responseBody: kDebugMode,
      error: true,
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint("Request: ${options.method} ${options.path}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint("Response: ${response.statusCode} ${response.data}");
        return handler.next(response);
      },
      onError: (DioError error, handler) {
        debugPrint("Error: ${error.message}");
        return handler.next(error);
      },
    ));
  }

  // Set headers
  static void _setHeaders(String? token) {
    dio.options.headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // Unified API call handler
  static Future<Response> request({
    required String method,
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      _setHeaders(token);
      switch (method.toUpperCase()) {
        case 'GET':
          return await dio.get(url, queryParameters: query);
        case 'POST':
          return await dio.post(url, queryParameters: query, data: data);
        case 'PUT':
          return await dio.put(url, queryParameters: query, data: data);
        case 'DELETE':
          return await dio.delete(url, queryParameters: query);
        default:
          throw UnsupportedError('Method $method is not supported');
      }
    } catch (e) {
      rethrow; // Rethrow error for further handling
    }
  }

  // GET Request
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) => request(method: 'GET', url: url, query: query, token: token);

  // POST Request
  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) => request(method: 'POST', url: url, query: query, data: data, token: token);

  // PUT Request
  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) => request(method: 'PUT', url: url, query: query, data: data, token: token);

  // DELETE Request
  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) => request(method: 'DELETE', url: url, query: query, token: token);
}