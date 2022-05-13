import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mtm/models/position_model.dart';
import 'package:mtm/providers/providers.dart';

class MapViewModel {
  //default location
  MtmsPosition sourcePosition = MtmsPosition(
    name: "",
    latitude: 0,
    longitude: 0,
  );
  MtmsPosition destinationPosition = MtmsPosition(
    name: "",
    latitude: 0,
    longitude: 0,
  );
  MtmsPosition myPosition = MtmsPosition(
    name: "myLocation",
    latitude: 38.685516,
    longitude: -101.073324,
  );
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  List<Marker> markers = <Marker>[];

  Future<void> getCurrentPosition(BuildContext context) async {
    context.read(mapNotifierProvider).loadMap();
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    _updatePostion(position.latitude, position.longitude);
    markers.add(
      Marker(
        markerId: const MarkerId('my_place'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: 'The title of the marker'),
      ),
    );
    // ignore: use_build_context_synchronously
    context.read(mapNotifierProvider).getMapLoaded();
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  void _updatePostion(double latitude, double longitude) {
    myPosition.latitude = latitude;
    myPosition.longitude = longitude;
  }
}
