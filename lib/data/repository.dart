import 'package:flutter/widgets.dart';
import 'package:to7_1/data/api.dart';
import 'package:to7_1/models/Station.dart';
import 'package:to7_1/models/BikeType.dart';

class Repository {
  final Api api;

  Repository({required this.api});

  Future<List<Station>> getListStation() async {
    final String _baseUrl = 'acoruna.publicbikesystem.net';

    final Map<String, dynamic> infoResponse = await api.getJson(
      Uri.https(_baseUrl, '/customer/gbfs/v2/gl/station_information'),
    );

    final Map<String, dynamic> statusResponse = await api.getJson(
      Uri.https(_baseUrl, '/customer/gbfs/v2/gl/station_status'),
    );

    final List<dynamic> infoList = infoResponse['data']['stations'] ?? [];
    final List<dynamic> statusList = statusResponse['data']['stations'] ?? [];

    /* final Map<String, dynamic> statusMapId = {
      for (var statusId in statusList) statusId['station_id']: statusId,
    };
    return infoList.map((info) {
      final String id = info['station_id'];
      final Map<String, dynamic> status = statusMapId[id] ?? {};*/

    return infoList.map((e) {
      final String id = e['station_id'];
      final statusElement = statusList.firstWhere(
        (element) => element['station_id'] == id,
        orElse: () => <String, dynamic>{},
      );

      final Map<String, dynamic> combinedMap = {};
      combinedMap.addAll(e);
      combinedMap.addAll(statusElement);
      return Station.fromJson(combinedMap);
    }).toList();
  }
}
