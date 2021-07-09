import 'package:flutter/material.dart';
import 'package:weathery/services/weather-service.dart';

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  late final Map<String, WeatherResponse> weatherMap = ModalRoute.of(context)!
      .settings
      .arguments as Map<String, WeatherResponse>;

  @override
  Widget build(BuildContext context) {
    var weather = weatherMap['data'] as WeatherResponse;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Weather for ${weather.name}'),
      ),
      body: Center(
        child: Stack(
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1581150257735-1c93ea8306ef?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
              fit: BoxFit.cover,
            ),
            Center(
              child: Text('The temperature is ${weather.temp}'),
            )
          ],
        ),
      ),
    );
  }
}
