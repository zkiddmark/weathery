import 'package:flutter/material.dart';
import 'package:weathery/services/weather-service.dart';

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  late WeatherResponse weather;
  late Map<String, WeatherService> weatherService =
      ModalRoute.of(context)!.settings.arguments as Map<String, WeatherService>;

  void updateWeatherLocation(String location) async {
    var ws = weatherService['data'] as WeatherService;
    await ws.getWeatherByLocation(location);
    setState(() => {weather = ws.currentWeather});
  }

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

  Widget _searchField(BuildContext context, Function onSubmit) {
    var textFieldController = TextEditingController();
    return Container(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white30),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  labelText: 'Enter a city name',
                  focusColor: Colors.white70,
                  focusedBorder: InputBorder(
                    borderSide: BorderSide(
                      color: Colors.amber,
                    ),
                  ),
                ),
                cursorColor: Colors.red,
                controller: textFieldController,
                onEditingComplete: () => {
                  updateWeatherLocation(textFieldController.text),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var ws = weatherService['data'] as WeatherService;
    weather = ws.currentWeather;
    // print(weather.name);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Weather for ${weather.name}'),
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
          child: Column(
            children: [
              Center(
                child: _searchField(context, ws.updateLocation),
              ),
              Center(
                child: createWeatherCard(weather),
              ),
            ],
          ),
        ));
  }
}
