
import 'package:dio/dio.dart';

class DioDataProvider {
  final Dio dio;

  DioDataProvider({required this.dio});

  // GET Request
  Future<Response> getDataProvider(String uri) async {
    try {
      final response = await dio.get(uri);
      return response;
    } catch (error, stackTrace) {
      print("Error: \$error\nStacktrace: \$stackTrace");
      return Future.error(error);
    }
  }

  // POST Request
  Future<Response> postData(String uri, Map<String, dynamic> data) async {
    try {
      final response = await dio.post(uri, data: data);
      return response;
    } catch (error, stackTrace) {
      print("POST Error: \$error\nStacktrace: \$stackTrace");
      return Future.error(error);
    }
  }

  // PUT Request
  Future<Response> putData(String uri, Map<String, dynamic> data) async {
    try {
      final response = await dio.put(uri, data: data);
      return response;
    } catch (error, stackTrace) {
      print("PUT Error: \$error\nStacktrace: \$stackTrace");
      return Future.error(error);
    }
  }

  // PATCH Request
  Future<Response> patchData(String uri, Map<String, dynamic> data) async {
    try {
      final response = await dio.patch(uri, data: data);
      return response;
    } catch (error, stackTrace) {
      print("PATCH Error: \$error\nStacktrace: \$stackTrace");
      return Future.error(error);
    }
  }

  // DELETE Request
  Future<Response> deleteData(String uri) async {
    try {
      final response = await dio.delete(uri);
      return response;
    } catch (error, stackTrace) {
      print("DELETE Error: \$error\nStacktrace: \$stackTrace");
      return Future.error(error);
    }
  }
}