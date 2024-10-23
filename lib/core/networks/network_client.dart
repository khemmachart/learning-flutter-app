import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class NetworkClient {
  final String baseUrl;
  final String apiKey;
  final Dio _dio;
  final Logger _logger = Logger();


  NetworkClient({Dio? dio})
      : baseUrl = dotenv.env['API_BASE_URL'] ?? '',
        apiKey = dotenv.env['API_KEY'] ?? '',
        _dio = dio ?? Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer $apiKey',
      'accept': 'application/json',
    };
    _logger.d('NetworkClient initialized with base URL: $baseUrl');
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
