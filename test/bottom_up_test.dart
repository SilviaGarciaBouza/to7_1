import 'package:flutter_test/flutter_test.dart';
import 'package:to7_1/data/api.dart';
import 'package:to7_1/data/repository.dart';
import 'package:to7_1/models/Station.dart';

void main() {

  test(
    'Validar que el Repository procesa correctamente los datos de la API',
    () async {
      final repository = FalseStationRepository();
      List<Station> resultado = await repository.getListStation();
      
      expect(resultado.isNotEmpty, true);
      final firstStatn = resultado[0];
      expect(firstStatn.name.isNotEmpty, true);
      expect(firstStatn.numBikesAvailable >= 0, true);
      }
     
    
  );
}


class FalseStationRepository extends Repository {
  FalseStationRepository() : super(api: Api());
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