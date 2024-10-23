import 'package:dio/dio.dart';

class NetworkClient {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1YjI5ZWNiOWI1YzlkY2E4ODBhZjE1YTZmM2NlNjgyZCIsIm5iZiI6MTcyODkyMDY4Ny42MjY2OTksInN1YiI6IjY3MGQzYmIxZDVmOTNhM2RhMGJiY2M3ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6SOjjGI7YB0-8H2oZuf5VZXAKXcSOykJmqfqTtOUlyE';

  final Dio _dio;

  NetworkClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer $_apiKey',
      'accept': 'application/json',
    };
  }

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParams);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load data: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load data: ${e.message}');
    }
  }
}
