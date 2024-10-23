import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkClient {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1YjI5ZWNiOWI1YzlkY2E4ODBhZjE1YTZmM2NlNjgyZCIsIm5iZiI6MTcyODkyMDY4Ny42MjY2OTksInN1YiI6IjY3MGQzYmIxZDVmOTNhM2RhMGJiY2M3ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6SOjjGI7YB0-8H2oZuf5VZXAKXcSOykJmqfqTtOUlyE';

  final http.Client _client;

  NetworkClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: queryParams);
    final response = await _client.get(
      uri,
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
