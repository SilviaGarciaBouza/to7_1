import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  final http.Client _client;
  Api({http.Client? client}) : _client = client ?? http.Client();
  Future<Map<String, dynamic>> getJson(Uri url) async {
    try {
      final response = await _client
          .get(url, headers: {'Accept': 'application/json'})
          //Gestión de Timeout: Ponemos un límite de 10 segundos.
          // Si el servidor no responde en ese tiempo, cortamos
          // la conexión para que la app no se quede esperando indefinidamente.
          .timeout(const Duration(seconds: 10));
      //Gestión del statusCode: Verificamos la respuesta del servidor.
      // - 400-499: Errores del cliente, de nuestra aplicación.
      // - 500-599: Errores del servidor.
      // - Si no es 200, lanzamos una excepción.
      if (response.statusCode >= 400 && response.statusCode < 500) {
        throw Exception('Error del cliente: ${response.statusCode}');
      } else if (response.statusCode >= 500) {
        throw Exception('Error del servidor: ${response.statusCode}');
      } else if (response.statusCode != 200) {
        throw Exception('Error: ${response.statusCode}');
      }
      //Gestión del json: El body de la respuesta debe ser texto json válido.
      final dynamic decoded;
      try {
        decoded = jsonDecode(response.body);
      } catch (e) {
        throw Exception('El json no es válido');
      }

      //Gestión del tipo de dato: Si el tipo de dato es diferente a Map<String, dynamic>
      //lo detectamos aquí antes de que el Repository intente usarlo haciendo fallar la aplicacion.
      if (decoded is! Map<String, dynamic>) {
        throw Exception(
          'Se esperaba un objeto JSON (Map<String, dynamic>), pero llegó: ${decoded.runtimeType}',
        );
      }
      return decoded;
    }
    //Gestión de error por timeout u otra causa.
    catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Fallo porque el servidor tardó demasiado tiempo.');
      } else {
        throw Exception('Error');
      }
    }
  }
}
