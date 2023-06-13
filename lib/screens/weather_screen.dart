import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graduation_app/models/weather.dart';
import 'package:graduation_app/resources/weather_api_client.dart';
import 'package:graduation_app/widgets/weather/additioanal_information.dart';
import 'package:graduation_app/widgets/weather/current_weather.dart';

import '../resources/location_services.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherApiClient client = WeatherApiClient();
  Weather? weatherData;

  Future<void> getWeatherData() async {
    Position position = await LocationServices.getCurrentLocation();
    weatherData =
        await client.getCurrentWeather(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      body: SafeArea(
        child: FutureBuilder(
          future: getWeatherData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          currentWeather(
                              Icons.wb_sunny_rounded,
                              weatherData!.temp.toString(),
                              weatherData!.cityName.toString()),
                          const SizedBox(height: 60),
                          const Text(
                            "Additional  Informaiton",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          const SizedBox(height: 20),
                          additioanalInformation(
                            weatherData!.wind.toString(),
                            weatherData!.humidity.toString(),
                            weatherData!.pressure.toString(),
                            weatherData!.feelsLike.toString(),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }
}
