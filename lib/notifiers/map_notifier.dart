import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class MapState {
  const MapState();
}

class MapIntial extends MapState {
  const MapIntial();
}

class MapLoading extends MapState {
  const MapLoading();
}

class MapLoaded extends MapState {
  const MapLoaded();
}

class MapError extends MapState {
  final String message;
  const MapError(this.message);
}

class MapNotifier extends StateNotifier<MapState> {
  MapNotifier() : super(const MapIntial());

  void loadMap() {
    state = const MapLoading();
  }

  void getMapLoaded() {
    state = const MapLoaded();
  }

  void getAccessDenied() {
    state = const MapError("Location Access denied by user 😥");
  }

  @override
  void dispose() {
    super.dispose();
  }
}
