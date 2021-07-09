import 'package:flutter/material.dart';
import 'package:weathery/services/weather-service.dart';

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  late Map<String, WeatherResponse> weatherMap = ModalRoute.of(context)!
      .settings
      .arguments as Map<String, WeatherResponse>;

  @override
  Widget build(BuildContext context) {
    print(weatherMap['data']!.name);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Weather for...'),
      ),
      body: Container(
        child: Text('Weathery'),
      ),
    );
  }
}
