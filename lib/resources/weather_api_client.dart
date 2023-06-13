import 'dart:convert';

import 'package:graduation_app/models/weather.dart';
import 'package:graduation_app/utils/key.dart';
import 'package:http/http.dart' as http;

class WeatherApiClient {
  Future<Weather>? getCurrentWeather(double lat, double long) async {
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$kApiKey&units=metric");
    var response = await http.get(url);
    var body = jsonDecode(response.body);
    Weather weather = Weather.fromJson(body);
    return weather;
  }
}
