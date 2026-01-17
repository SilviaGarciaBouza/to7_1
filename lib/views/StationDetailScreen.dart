import 'package:flutter/material.dart';
import 'package:to7_1/models/Station.dart';

class StationDetailScreen extends StatelessWidget {
  final Station station;

  const StationDetailScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    //Comprobamos que los colores se muestran correctamente
    // según el estado que recibimos del ViewModel.
    Color statusColor = (station.numBikesAvailable == 0)
        ? Colors.red
        : (station.numBikesAvailable < 8)
        ? Colors.orange
        : Colors.green;

    final date = DateTime.fromMillisecondsSinceEpoch(
      station.lastReported * 1000,
    );
    final time =
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    //Comprobamos que el cálculo de puestos inhabilitados es correcto
    final int inhabilitados =
        station.capacity -
        (station.numBikesAvailable + station.numDocksAvailable);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(station.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Actualizado: $time",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor, width: 2),
              ),
              child: Column(
                children: [
                  Tooltip(
                    message: 'Bicicletas totales disponibles',
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.pedal_bike, size: 40, color: statusColor),
                        Text(
                          "${station.numBikesAvailable}",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var type in station.availableTypes)
                    if (!type.id.toLowerCase().contains("boost"))
                      Column(
                        children: [
                          Icon(
                            type.id.toUpperCase() == 'EFIT'
                                ? Icons.electric_bike
                                : Icons.directions_bike,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${type.id.toUpperCase()} Libres',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "${type.count}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                  Container(height: 40, width: 1, color: Colors.grey.shade200),

                  Column(
                    children: [
                      const Icon(Icons.local_parking, color: Colors.blue),
                      const SizedBox(height: 4),
                      const Text(
                        "Vacíos",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        "${station.numDocksAvailable}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  Container(height: 40, width: 1, color: Colors.grey.shade200),

                  Column(
                    children: [
                      const Icon(
                        Icons.build_circle_outlined,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Rotos",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        "${inhabilitados < 0 ? 0 : inhabilitados}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Capacidad total de la estación: ${station.capacity}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
