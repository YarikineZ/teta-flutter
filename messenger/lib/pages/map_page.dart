import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Marker buildPin(LatLng point) => Marker(
        point: point,
        builder: (ctx) => const Icon(
          Icons.location_pin,
          size: 60,
          color: Colors.redAccent,
        ),
        width: 60,
        height: 60,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(51.509364, -0.128928),
          zoom: 9.2,
          // interactiveFlags: InteractiveFlag.rotate
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              buildPin(const LatLng(51.51868093513547, -0.12835376940892318)),
            ],
          )
        ],
      ),
    );
  }
}
