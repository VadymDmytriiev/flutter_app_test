import 'package:flutter/material.dart';
import 'package:flutter_app_test/screens/weather_screen.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherScreen(),
    );
  }
}
