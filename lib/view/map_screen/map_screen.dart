import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlng;

class MapScreen extends StatelessWidget {
  final MapController controller = Get.put(MapController());
  final Position? currentLocation;
  MapScreen({super.key, required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Map with Current Location'),
        ),
        body: currentLocation == null
            ? CircularProgressIndicator()
            : _buildMap(currentLocation!));
  }

  Widget _buildMap(Position currentLocation) {
    return FlutterMap(
      options: MapOptions(
        initialCenter:
            latlng.LatLng(currentLocation.latitude, currentLocation.longitude),
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(markers: [
          Marker(
            width: 40.0,
            height: 40.0,
            point: latlng.LatLng(
                currentLocation.latitude, currentLocation.longitude),
            child: const Icon(
              Icons.location_on,
              size: 40.0,
              color: Colors.red,
            ),
          ),
        ])
      ],
    );
  }
}
