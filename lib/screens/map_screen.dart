import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_app/resources/location_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graduation_app/screens/weather_screen.dart';

import 'translate_text_camera_recognition_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  double longitude = 0;
  double latitude = 0;
  String address = "";
  static Set<Marker> myMarkers = {};
  late GoogleMapController googleMapController;

  void getCurrentPosition() async {
    Position currentPosition = await LocationServices.getCurrentLocation();
    dynamic address = await LocationServices.getPlaceAddress(
        currentPosition.latitude, currentPosition.longitude);

    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(currentPosition.latitude, currentPosition.longitude),
            zoom: 14),
      ),
    );
    myMarkers.clear();

    myMarkers.add(
      Marker(
        markerId: const MarkerId("currentLocation"),
        position: LatLng(currentPosition.latitude, currentPosition.longitude),
        infoWindow: InfoWindow(
            title: "Me", snippet: address['results'][0]['formatted_address']),
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Services"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const TranslateTextCameraRecognition(),
              ));
            },
            icon: const Icon(Icons.translate),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const WeatherScreen(),
              ));
            },
            icon: const Icon(Icons.cloud),
          ),
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
        ),
        markers: myMarkers,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
    );
  }
}
