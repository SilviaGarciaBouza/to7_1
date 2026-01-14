import 'package:flutter_test/flutter_test.dart';
import 'package:to7_1/data/api.dart';
import 'package:to7_1/data/repository.dart';
import 'package:to7_1/models/Station.dart';

void main() {
  test(
    'Validar que el Repository procesa correctamente los datos reales de la API',
    () async {
      final api = Api();
      final repository = Repository(api: api);
      List<Station> resultado = await repository.getListStation();
      expect(resultado.isNotEmpty, true);
      final firstStatn = resultado[0];
      expect(firstStatn.name.isNotEmpty, true);
      expect(firstStatn.numBikesAvailable >= 0, true);
    },
  );
}
