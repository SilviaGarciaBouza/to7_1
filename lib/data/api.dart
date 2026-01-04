import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  final http.Client _client;
  Api({http.Client? client}) : _client = client ?? http.Client();

  Future<List<dynamic>> getStation(Uri url) async {
    // final url = Uri.https(
    // 'acoruna.publicbikesystem.net',
    // '/customer/gbfs/v2/gl/station_information',
    // );
    final response = await _client
        .get(url, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('GET ${url.path} : ${response.statusCode}');
    }
    final decoded = jsonDecode(response.body);
    //return json['data']['stations'];
    if (decoded is! Map<String, dynamic>) {
      throw Exception(
        'Se esperaba un mapa JSON, pero llegó ${decoded.runtimeType}',
      );
    }
    return decoded['data']['stations'];
  }
}


/*
  Future<List<dynamic>> getStationStatus() async {
    //final url = Uri.https(
      //'acoruna.publicbikesystem.net',
     // '/customer/gbfs/v2/gl/station_status',
    //);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      //return json['data']['stations'];
      if(json is! List){
        throw Exception('Se esperaba lista JSON, pero llegó ${json.runtimeType}')
      }
      return json;
    } else {
      throw Exception('Error cargando station_status: ${response.statusCode}');
    }
  }
}
*/