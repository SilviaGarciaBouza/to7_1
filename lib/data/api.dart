import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String _baseUrl = 'acoruna.publicbikesystem.net';
  final http.Client _client;

  Api({http.Client? client}) : _client = client ?? http.Client();

  Future<List<dynamic>> _getJson(String path) async {
    final url = Uri.https(_baseUrl, path);
    final response = await _client.get(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error HTTP ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    return decoded['data']['stations'] as List<dynamic>;
  }

  Future<List<dynamic>> getStationInformation() =>
      _getJson('/customer/gbfs/v2/gl/station_information');

  Future<List<dynamic>> getStationStatus() =>
      _getJson('/customer/gbfs/v2/gl/station_status');
}
