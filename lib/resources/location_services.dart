import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:graduation_app/utils/key.dart';
import 'package:http/http.dart' as http;

class LocationServices {
  static Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  static Future<dynamic> getPlaceAddress(double lat, double long) async {
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$kGoogleMapAPI";
    http.Response response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    return data;
  }

  static String getPlaceLocationImage(double lat, double long) {
    final String url =
        "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=14&size=300x300&markers=color:red%7Clabel:Post%7C$lat,$long&key=$kGoogleMapAPI";
    return url;
  }
}
