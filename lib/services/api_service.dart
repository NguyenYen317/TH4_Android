import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:th4_e_commerce_app/utils/constants.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<dynamic>> getList(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(
      '${AppConstants.apiBaseUrl}$endpoint',
    ).replace(queryParameters: queryParams);

    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('API error ${response.statusCode} for $endpoint');
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is List<dynamic>) {
      return decoded;
    }

    throw Exception('Invalid response format for $endpoint');
  }

  void dispose() {
    _client.close();
  }
}
