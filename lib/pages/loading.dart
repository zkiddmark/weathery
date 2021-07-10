import 'package:flutter/material.dart';
import 'package:weathery/services/weather-service.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void getWeather() async {
    var weatherService = await WeatherService.create();
    await weatherService.getWeatherByCoordinates(
        weatherService.geoLocatorService.currentPosition.latitude,
        weatherService.geoLocatorService.currentPosition.longitude);

    // Transition to Weather
    Navigator.pushReplacementNamed(context, '/weather',
        arguments: {'data': weatherService});
  }

  @override
  void initState() {
    getWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Weathery'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.blueAccent),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.orangeAccent,
          ),
        ),
      ),
    );
  }
}
