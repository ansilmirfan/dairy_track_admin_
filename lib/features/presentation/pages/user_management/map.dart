import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
//------------company location-------------------
  static const CameraPosition _companyLocation = CameraPosition(
    target: LatLng(11.641607, 76.110927),
    zoom: 17,
  );

  //-------------markers-------------
  Set<Marker> markers = <Marker>{};
  @override
  void initState() {
    super.initState();
    _loadCompanyLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _companyLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
        onLongPress: (argument) {
          Get.back(result: argument);
        },
      ),
    );
  }

  _loadCompanyLocation() async {
    markers.add(
      Marker(
          markerId: const MarkerId('Company Location'),
          infoWindow: const InfoWindow(title: 'company'),
          icon: BitmapDescriptor.defaultMarkerWithHue(120),
          position: LatLng(_companyLocation.target.latitude,
              _companyLocation.target.longitude)),
    );
  }
}
