import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mtm/const/app_const.dart';
import 'package:mtm/notifiers/map_notifier.dart';
import 'package:mtm/providers/providers.dart';
import 'package:mtm/shared/action_btn.dart';
import 'package:mtm/shared/side_menu.dart';
import 'package:mtm/shared/txt_field.dart';
import 'package:mtm/view_models/map_viewmodel.dart';
import 'package:mtm/views/destination_items_screen.dart';
import 'package:mtm/views/source_search_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapViewModel _mapViewModel = MapViewModel();
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMapView();
  }

  Future<void> loadMapView() async {
    await _mapViewModel.getCurrentPosition(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        leading: const SizedBox(),
        title: Text(
          "MTMs task",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: ProviderListener(
        provider: mapNotifierProvider.state,
        onChange: (context, watch) {},
        child: Consumer(
          builder: (context, watch, child) {
            final state = watch(mapNotifierProvider.state);
            if (state is MapLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MapLoaded) {
              return Stack(
                children: [
                  GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _mapViewModel.myPosition.latitude!,
                        _mapViewModel.myPosition.longitude!,
                      ),
                      zoom: 14.4746,
                    ),
                    markers: Set<Marker>.of(_mapViewModel.markers),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 36.0,
                        horizontal: 16,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: () {
                                          Scaffold.of(context).openDrawer();
                                        },
                                        child: const Icon(
                                          Icons.list,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Txtfield(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => SourceSearchScreen(
                                          controller: sourceController,
                                          mapViewModel: _mapViewModel,
                                        ),
                                      ),
                                    );
                                  },
                                  controller: sourceController,
                                  label: "Your location",
                                  isReadOnly: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Txtfield(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => DestinationItemsScreen(
                                          controller: destinationController,
                                          mapViewModel: _mapViewModel,
                                        ),
                                      ),
                                    );
                                  },
                                  controller: destinationController,
                                  label: "Destination",
                                  isReadOnly: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ActionBtn(
                        onPressed: () async {
                          String msg = "";
                          if (sourceController.text.isEmpty ||
                              destinationController.text.isEmpty) {
                            Flushbar(
                              flushbarPosition: FlushbarPosition.TOP,
                              title: "Note",
                              duration: const Duration(seconds: 3),
                              message: "Please fill all fields",
                              backgroundGradient: const LinearGradient(
                                colors: [Color(0xFF0860A8), Colors.white],
                              ),
                            ).show(context);
                            return;
                          }
                          final _distanceInMeters = Geolocator.distanceBetween(
                            _mapViewModel.destinationPosition.latitude!,
                            _mapViewModel.destinationPosition.longitude!,
                            _mapViewModel.sourcePosition.latitude!,
                            _mapViewModel.sourcePosition.longitude!,
                          );

                          if (_distanceInMeters < 1000) {
                            msg = "$_distanceInMeters meters";
                          } else {
                            msg = "${_distanceInMeters / 1000} KM";
                          }
                          Flushbar(
                            title: "Distance",
                            flushbarPosition: FlushbarPosition.TOP,
                            duration: const Duration(seconds: 3),
                            message: msg,
                            backgroundGradient: const LinearGradient(
                              colors: [Color(0xFF0860A8), Colors.white],
                            ),
                          ).show(context);
                        },
                        label: "REQUEST RD",
                      ),
                    ),
                  )
                ],
              );
            }
            if (state is MapError) {
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          AppConstants.DENIED,
                          width: 0.8.sw,
                          height: 0.15.sh,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          "Please accept location permission",
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
