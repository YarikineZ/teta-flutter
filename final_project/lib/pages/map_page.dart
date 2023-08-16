import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late List<Marker> markers;
  bool _isLocated = false;

  @override
  void initState() {
    super.initState();
  }

  void _setPosition() async {
    var pos = await _determinePosition();
    markers = [buildPin(LatLng(pos.latitude, pos.longitude))];

    _isLocated = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
            center: const LatLng(51.509364, -0.128928),
            zoom: 5.2,
            enableScrollWheel: false,
            interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          _isLocated
              ? MarkerLayer(markers: markers)
              : const Text("null safety..")
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _setPosition,
        child: const Icon(Icons.pin_drop),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

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
}
