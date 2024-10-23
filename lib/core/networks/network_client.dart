import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class NetworkClient {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1YjI5ZWNiOWI1YzlkY2E4ODBhZjE1YTZmM2NlNjgyZCIsIm5iZiI6MTcyODkyMDY4Ny42MjY2OTksInN1YiI6IjY3MGQzYmIxZDVmOTNhM2RhMGJiY2M3ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6SOjjGI7YB0-8H2oZuf5VZXAKXcSOykJmqfqTtOUlyE';

  final Dio _dio;
  final Logger _logger = Logger();

  NetworkClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer $_apiKey',
      'accept': 'application/json',
    };
    _logger.d('NetworkClient initialized with base URL: $_baseUrl');
  }

  Future<Map<String, dynamic>> _handleRequest(Future<Response<dynamic>> Function() requestFunction, String endpoint) async {
    try {
      final response = await requestFunction();

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        _logger.d('Successful response from $endpoint');
        return response.data ?? {};
      } else {
        _logger.e('Failed to process request: ${response.statusCode}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to process request: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _logger.e('DioException: ${e.message}', error: e, stackTrace: e.stackTrace);
      throw Exception('Failed to process request: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    _logger.i('GET request to $endpoint with query params: $queryParams');
    return _handleRequest(() => _dio.get(endpoint, queryParameters: queryParams), endpoint);
  }

  Future<Map<String, dynamic>> post(String endpoint, {Map<String, String>? queryParams, dynamic data}) async {
    _logger.i('POST request to $endpoint with query params: $queryParams and data: $data');
    return _handleRequest(() => _dio.post(endpoint, queryParameters: queryParams, data: data), endpoint);
  }

  Future<Map<String, dynamic>> put(String endpoint, {Map<String, String>? queryParams, dynamic data}) async {
    _logger.i('PUT request to $endpoint with query params: $queryParams and data: $data');
    return _handleRequest(() => _dio.put(endpoint, queryParameters: queryParams, data: data), endpoint);
  }

  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, String>? queryParams}) async {
    _logger.i('DELETE request to $endpoint with query params: $queryParams');
    return _handleRequest(() => _dio.delete(endpoint, queryParameters: queryParams), endpoint);
  }
}
