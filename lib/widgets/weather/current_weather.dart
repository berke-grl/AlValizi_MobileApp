import 'package:flutter/material.dart';

Widget currentWeather(IconData icon, String temp, String location) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.orange,
          size: 64,
        ),
        const SizedBox(height: 10),
        Text(temp, style: const TextStyle(fontSize: 46)),
        const SizedBox(height: 10),
        Text(location,
            style: const TextStyle(fontSize: 18, color: Colors.grey)),
      ],
    ),
  );
}
