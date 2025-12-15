import 'package:flutter/material.dart';
import 'package:to7_1/models/Station.dart';

class StationDetailScreen extends StatelessWidget {
  final Station station;
  const StationDetailScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    // 1. Convertir fecha
    final date = DateTime.fromMillisecondsSinceEpoch(
      station.lastReported * 1000,
    );
    final hora =
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            station.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          tooltip: 'Volver',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 18, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  "Actualizado a las $hora",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

            SizedBox(height: 32),

            Row(
              children: [
                _InfoCard(
                  label: "Total",
                  value: "${station.capacity}",
                  icon: Icons.dns_rounded,
                  color: Colors.blue,
                ),
                SizedBox(width: 12),
                _InfoCard(
                  label: "Huecos libres",
                  value: "${station.numDocksAvailable}",
                  icon: Icons.local_parking_rounded,
                  color: Colors.grey,
                ),
                SizedBox(width: 12),
                _InfoCard(
                  label: "Bicis disponibles",
                  value: "${station.numBikesAvailable}",
                  icon: Icons.pedal_bike_rounded,
                  color: Colors.green,
                ),
              ],
            ),

            SizedBox(height: 32),

            Text(
              "Disponibilidad",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            if (station.availableTypes.isEmpty)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey[500]),
                    SizedBox(width: 12),
                    Text(
                      "No hay información detallada.",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            else
              ...station.availableTypes.where((t) => t.count > 0).map((type) {
                final isElectric =
                    type.id.toUpperCase().contains('ELECTRIC') ||
                    type.id.toUpperCase().contains('EF') ||
                    type.id.toUpperCase().contains('BOOST');

                // COLORES:
                final colorTema = isElectric
                    ? Colors.amber[700]!
                    : Colors.purple;
                final colorFondo = isElectric
                    ? Colors.amber[50]!
                    : Colors.purple[50]!;
                final tipoTexto = isElectric ? "Eléctrica" : "Mecánica";

                return Tooltip(
                  message: '$tipoTexto (Modelo ${type.id})',
                  triggerMode: TooltipTriggerMode.tap,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: colorFondo,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorTema.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          isElectric
                              ? Icons.electric_bolt_rounded
                              : Icons.pedal_bike_rounded,
                          color: colorTema,
                          size: 32,
                        ),

                        // SOLO NÚMERO
                        Text(
                          "${type.count}",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorTema,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
