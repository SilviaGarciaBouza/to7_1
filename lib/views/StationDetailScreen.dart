import 'package:flutter/material.dart';
import 'package:to7_1/models/Station.dart';

class StationDetailScreen extends StatelessWidget {
  final Station station;
  const StationDetailScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final DateTime updateTime = DateTime.fromMillisecondsSinceEpoch(
      station.lastReported * 1000,
    );
    final String timeStr =
        "${updateTime.hour.toString().padLeft(2, '0')}:${updateTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(station.name, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Actualizado: $timeStr",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.pedal_bike, color: Colors.green, size: 30),
                      const SizedBox(width: 15),
                      Text(
                        "Bicis disponibles",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${station.numBikesAvailable}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.pedal_bike,
                        color: Colors.greenAccent,
                        size: 30,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "Anclajes libres",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${station.numDocksAvailable}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.pedal_bike, color: Colors.blue, size: 30),
                      const SizedBox(width: 15),
                      Text(
                        "Puestos totales",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${station.capacity}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 40),
            const Text(
              "Detalle por tipo",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: station.availableTypes.map((type) {
                final bool isElectric = type.id.toLowerCase().contains("efit");

                return ListTile(
                  leading: Icon(
                    isElectric
                        ? Icons.bolt
                        : type.id.toLowerCase().contains("fit")
                        ? Icons.directions_bike
                        : null,
                    color: Colors.purple,
                  ),
                  title: Text(
                    type.id.toLowerCase().contains("efit")
                        ? "Eléctrica (EFIT)"
                        : type.id.toLowerCase().contains("fit")
                        ? "Mecánica (FIT)"
                        : " ",
                  ),
                  trailing: Text(
                    type.id.toLowerCase().contains("efit")
                        ? "${type.count}"
                        : type.id.toLowerCase().contains("fit")
                        ? "${type.count}"
                        : " ",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget básico para las tarjetas de información
class _SimpleCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _SimpleCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5), width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
