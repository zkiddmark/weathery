import 'package:flutter/material.dart';
import 'package:weathery/services/geolocator-service.dart';
import 'package:weathery/services/weather-service.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late GeoLocatorService geoService;

  void getLocation() async {
    geoService = await GeoLocatorService.create();
    await getWeather();
  }

  Future getWeather() async {
    var weatherService = WeatherService();
    var weather = await weatherService.getWeatherByCoordinates(
        geoService.currentPosition.latitude,
        geoService.currentPosition.longitude);
    print(weather.temp);

    // Transition to Weather
    Navigator.pushReplacementNamed(context, '/weather',
        arguments: {'data': weather});
  }

  @override
  void initState() {
    getLocation();
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
        child: Text('Loading'),
      ),
    );
  }
}
