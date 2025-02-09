import 'package:dio/dio.dart';

enum DioMethod { get, post, put, delete }

class APIService {
  // Singleton instance
  APIService._singleton();
  static final instance = APIService._singleton();

  // Base URL for the API
  String get baseUrl {
    return 'https://restaurant-api.dicoding.dev';
  }

  // Main request method
  Future<Response> request(
    String endpoint,
    DioMethod method, {
    Map<String, dynamic>? param,
    String? contentType,
    dynamic formData,
  }) async {
    // Initialize Dio with base options
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        contentType: contentType ?? Headers.jsonContentType,
      ),
    );

    try {
      // Determine the HTTP method
      Response response;
      switch (method) {
        case DioMethod.get:
          response = await dio.get(endpoint, queryParameters: param);
          break;
        case DioMethod.post:
          response = await dio.post(endpoint, data: formData ?? param);
          break;
        case DioMethod.put:
          response = await dio.put(endpoint, data: formData ?? param);
          break;
        case DioMethod.delete:
          response = await dio.delete(endpoint, queryParameters: param);
          break;
      }

      // Return the response
      return response;
    } on DioException catch (e) {
      // Handle Dio errors
      throw Exception('DioError: ${e.message}');
    } catch (e) {
      // Handle other errors
      throw Exception('Unexpected error: $e');
    }
  }
}
