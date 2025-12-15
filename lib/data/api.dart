import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  Future<List<dynamic>> getStationInfo() async {
    final url = Uri.https(
      'acoruna.publicbikesystem.net',
      '/customer/gbfs/v2/gl/station_information',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data']['stations'];
    } else {
      throw Exception('Error cargando información: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getStationStatus() async {
    final url = Uri.https(
      'acoruna.publicbikesystem.net',
      '/customer/gbfs/v2/gl/station_status',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data']['stations'];
    } else {
      throw Exception('Error cargando estado: ${response.statusCode}');
    }
  }
}
