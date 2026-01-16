import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  final http.Client _client;

  Api({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> getJson(Uri url) async {
    final response = await _client
        .get(url, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 10));


    if (response.statusCode != 200) {
      throw Exception('GET ${url.path} -> ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception(
        'Se esperaba un objeto JSON (Map<String, dynamic>), pero llegó: ${decoded.runtimeType}',
      );
    }
    return decoded;
  }
}
