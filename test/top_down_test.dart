import 'package:flutter_test/flutter_test.dart';
import 'package:to7_1/data/api.dart';
import 'package:to7_1/data/repository.dart';
import 'package:to7_1/models/Station.dart';
import 'package:to7_1/viewmodels/stationViewModel.dart';

class FalseApi extends Api {}

class FalseStationRepository extends Repository {
  FalseStationRepository() : super(api: FalseApi());
  @override
  Future<List<Station>> getListStation() async {
    return [
      Station(
        id: '1',
        name: 'Prueba',
        capacity: 10,
        numBikesAvailable: 5,
        numDocksAvailable: 5,
        lastReported: 0,
        availableTypes: [],
      ),
    ];
  }
}

void main() {
  test('Carga correcta de estaciones desde el viewmodel', () async {
    final vm = Stationviewmodel(repository: FalseStationRepository());
    await vm.loadStations();
    expect(vm.listStation.length, 1);
    expect(vm.listStation[0].name, 'Prueba');
  });
}
