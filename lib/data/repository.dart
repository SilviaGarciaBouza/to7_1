import 'package:to7_1/data/api.dart';
import 'package:to7_1/models/Station.dart';
import 'package:to7_1/models/BikeType.dart';

class Repository {
  final Api api;

  Repository({required this.api});

  Future<List<Station>> getListStation() async {
    final List<dynamic> infoList = await api.getStationInformation();
    final List<dynamic> statusList = await api.getStationStatus();

    return infoList.map((info) {
      final status = statusList.firstWhere(
        (s) => s['station_id'] == info['station_id'],
        orElse: () => {},
      );

      return Station(
        id: info['station_id'] ?? 'unknown',
        name: info['name'] ?? 'Sin nombre',
        capacity: info['capacity'] ?? 0,
        numBikesAvailable: status['num_bikes_available'] ?? 0,
        numDocksAvailable: status['num_docks_available'] ?? 0,
        lastReported: status['last_reported'] ?? 0,
        availableTypes: (status['vehicle_types_available'] as List? ?? [])
            .map((v) => BikeType.fromJson(v))
            .toList(),
      );
    }).toList();
  }
}
