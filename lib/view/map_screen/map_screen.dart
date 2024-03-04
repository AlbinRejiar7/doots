import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatelessWidget {
  final MapController controller = Get.put(MapController());
  final Position? currentLocation;
  MapScreen({super.key, required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Map with Current Location'),
        ),
        body: currentLocation == null
            ? const CircularProgressIndicator()
            : _buildMap(currentLocation!));
  }

  Widget _buildMap(Position currentLocation) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: latlng.LatLng(
              currentLocation.latitude, currentLocation.longitude),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.doots',
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
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
      ),
    );
  }
}
