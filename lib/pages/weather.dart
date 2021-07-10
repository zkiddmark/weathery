import 'package:flutter/material.dart';
import 'package:weathery/services/weather-service.dart';

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  late Map<String, WeatherService> weatherService =
      ModalRoute.of(context)!.settings.arguments as Map<String, WeatherService>;

  Widget createWeatherCard(WeatherResponse weather) {
    var iconUrl =
        'http://openweathermap.org/img/wn/${weather.weather.first.icon}@2x.png';
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  iconUrl,
                ),
              ],
            ),
            Divider(
              color: Colors.black26,
            ),
            Text('The temperature is ${weather.temp}'),
            Text(weather.weather.first.description)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var weather = weatherService['data'] as WeatherService;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Weather for ${weather.currentWeather.name}'),
          actions: [
            IconButton(
              onPressed: () async =>
                  {await weather.geoLocatorService.determinePosition()},
              icon: Icon(Icons.pin_drop_outlined),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                'https://images.unsplash.com/photo-1581150257735-1c93ea8306ef?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
              ),
            ),
          ),
          child: Center(
            child: createWeatherCard(weather.currentWeather),
          ),
        ));
  }
}
