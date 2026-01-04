import 'package:to7_1/data/api.dart';
import 'package:to7_1/models/Station.dart';
import 'package:to7_1/models/BikeType.dart';

class Repository {
  Repository({required this.api});
  final Api api;

  Future<List<Station>> getListStation() async {
    final urlInfo = Uri.https(
      'acoruna.publicbikesystem.net',
      '/customer/gbfs/v2/gl/station_information',
    );

    final urlStatus = Uri.https(
      'acoruna.publicbikesystem.net',
      '/customer/gbfs/v2/gl/station_status',
    );
    try {
      List<Station> stationsList = [];
      final infoJson = await api.getStation(urlInfo);
      final statusJson = await api.getStation(urlStatus);
      for (var info in infoJson) {
        final status = statusJson.firstWhere(
          (s) => s['station_id'] == info['station_id'],
          orElse: () => {},
        );

        List<BikeType> typesList = [];
        if (status['vehicle_types_available'] != null) {
          for (var v in status['vehicle_types_available']) {
            typesList.add(BikeType.fromJson(v));
          }
        }

        final station = Station(
          id: info['station_id'] ?? 'unknown',
          name: info['name'] ?? 'Sin nombre',
          capacity: info['capacity'] ?? 0,
          numBikesAvailable: status['num_bikes_available'] ?? 0,
          numDocksAvailable: status['num_docks_available'] ?? 0,
          lastReported: status['last_reported'] ?? 0,
          availableTypes: typesList,
        );

        stationsList.add(station);
      }

      return stationsList;
    } catch (e) {
      throw Exception('Error al combinar datos: $e');
    }
  }
}
