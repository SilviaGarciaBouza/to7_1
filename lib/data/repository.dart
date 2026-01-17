import 'package:flutter/widgets.dart';
import 'package:to7_1/data/api.dart';
import 'package:to7_1/models/Station.dart';
import 'package:to7_1/models/BikeType.dart';

class Repository {
  final Api api;
  Repository({required this.api});
  Future<List<Station>> getListStation() async {
    final String _baseUrl = 'acoruna.publicbikesystem.net';
    //Petición de datos: Hacemos las dos llamadas necesarias a la API.
    // Si la API lanza una excepción aquí, el proceso se detiene
    // automáticamente y el error sube al ViewModel.
    final Map<String, dynamic> infoResponse = await api.getJson(
      Uri.https(_baseUrl, '/customer/gbfs/v2/gl/station_information'),
    );
    final Map<String, dynamic> statusResponse = await api.getJson(
      Uri.https(_baseUrl, '/customer/gbfs/v2/gl/station_status'),
    );
    //Comprobación de la estructura del json
    // Primero miramos si existe  'data'
    if (!infoResponse.containsKey('data') ||
        !statusResponse.containsKey('data')) {
      throw Exception('El formato de respuesta de la API no es correcta.');
    }

    // Y luego miramos si dentro de 'data' existe 'stations'
    if (!infoResponse['data'].containsKey('stations') ||
        !statusResponse['data'].containsKey('stations')) {
      throw Exception('El formato de respuesta de la API no es correcta.');
    }

    // Convertimos los datos en listas de mapas.
    // Usamos .cast<Map<String, dynamic>>() para asegurar que cada elemento
    // tenga el formato exacto que esperan los modelos, evitando errores de tipo.
    final infoList = (infoResponse['data']['stations'] as List)
        .cast<Map<String, dynamic>>();
    final statusList = (statusResponse['data']['stations'] as List)
        .cast<Map<String, dynamic>>();

    // Si no hay estaciones, devolvemos una lista vacía en lugar de dar error.
    if (infoList.isEmpty) {
      return [];
    }
    //Unimos los datos.
    return infoList.map((e) {
      final String id = e['station_id'];
      //Buscamos en la segunda lista los datos que coincidan por ID.
      //firstWhere: Encuentra el estado actual de esa estación específica.
      //orElse: Si una estación es nueva y aún no tiene datos de estado,
      //            devolvemos un mapa vacío para que la app no se rompa al intentar leerla.
      final statusElement = statusList.firstWhere(
        (element) => element['station_id'] == id,
        orElse: () => <String, dynamic>{},
      );
      //Combinamos los datos y transformamos en objetos Station.
      //Si algún campo falla se le da su valor por defecto (establecido en el modelo en Station.fromJson())
      final Map<String, dynamic> combinedMap = {};
      combinedMap.addAll(e);
      combinedMap.addAll(statusElement);
      return Station.fromJson(combinedMap);
    }).toList();
  }
}




/*

class ApiTest extends Api {
  @override
  Future<Map<String, dynamic>> getJson(Uri url) async {
    //  Devolvemos datos fijos para que la UI y el ViewModel puedan
    // funcionar sin necesidad de conectar con el servidor real.
    return {
      'data': {
        'stations': [
          {'station_id': '1', 'name': 'Prueba', 'capacity': 10},
        ],
      },
    };
  }
}
*/























   /* final Map<String, dynamic> statusMapId = {
      for (var statusId in statusList) statusId['station_id']: statusId,
    };
    return infoList.map((info) {
      final String id = info['station_id'];
      final Map<String, dynamic> status = statusMapId[id] ?? {};*/