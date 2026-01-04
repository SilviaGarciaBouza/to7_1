import 'package:to7_1/models/BikeType.dart';

class Station {
  Station({
    required this.id,
    required this.name,
    required this.capacity,
    required this.numBikesAvailable,
    required this.numDocksAvailable,
    required this.lastReported,
    required this.availableTypes,
  });

  //https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_information
  final String id;
  final String name;
  final int capacity;
  //https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_status
  final int numBikesAvailable;
  final int numDocksAvailable;
  final int lastReported;
  final List<BikeType> availableTypes;

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['station_id'] ?? 'id unknown',
      name: json['name'] ?? 'name unknown',
      capacity: json['capacity'] ?? 0,
      numBikesAvailable: json['num_bikes_available'] ?? 0,
      numDocksAvailable: json['num_docks_available'] ?? 0,
      lastReported: json['last_reported'] ?? 0,
      availableTypes: [],
    );
  }

  String getName() {
    return name;
  }
}
