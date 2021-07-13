import 'package:flutter/material.dart';
import 'package:weathery/models/weathermodel.dart';
import 'package:weathery/pages/widgets/forecast.dart';
import 'package:weathery/services/weather-service.dart';
import 'dart:math' as math;

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  late WeatherResponse weather;
  late Map<String, WeatherService> weatherService =
      ModalRoute.of(context)!.settings.arguments as Map<String, WeatherService>;

  TextEditingController _textEditingController = TextEditingController();
  void updateWeatherLocation(String location) async {
    var ws = weatherService['data'] as WeatherService;
    await ws.getWeatherByLocation(location);
    _textEditingController.clear();
    setState(() => {weather = ws.currentWeather});
  }

  _createWeatherCard(WeatherResponse weather) {
    // ignore: unnecessary_null_comparison
    var iconUrl = weather.weather.first.icon != null
        ? 'http://openweathermap.org/img/wn/${weather.weather.first.icon}@2x.png'
        : 'local';
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconUrl == 'local'
                    ? Icon(Icons.circle)
                    : Image.network(
                        iconUrl,
                      ),
              ],
            ),
            Divider(
              color: Colors.black26,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('The temperature is ${weather.temp}'),
                    Text(weather.weather.first.description),
                  ],
                ),
                _windDirection(weather.wind.deg),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
          ],
        ),
      ),
    );
  }

  // _createForecastCard(WeatherForecastResponse forecast) {
  //   return ListView.builder(
  //     itemCount: forecast.forecast.length,
  //     shrinkWrap: true,
  //     itemBuilder: (context, index) {
  //       return Card(
  //         key: UniqueKey(),
  //         child: Text(forecast.forecast[index].weather.first.description),
  //       );
  //     },
  //   );
  // }

  _searchField(BuildContext context) {
    return Container(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: TextField(
            decoration: InputDecoration(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              labelText: 'Enter a city name',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            style: TextStyle(
              color: Colors.white,
            ),
            cursorColor: Colors.red,
            controller: _textEditingController,
            onEditingComplete: () => {
              updateWeatherLocation(_textEditingController.text),
            },
          ),
        ),
      ),
    );
  }

  _windDirection(int angle) {
    return Transform.rotate(
      angle: angle * math.pi / 180,
      child: Icon(
        Icons.arrow_upward,
        color: Colors.black,
      ),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              'https://images.unsplash.com/photo-1581150257735-1c93ea8306ef?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _searchField(context),
            _createWeatherCard(weather),
            WeatherForecast(
              weatherForecastResponse: weather.forecast,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var ws = weatherService['data'] as WeatherService;
    weather = ws.currentWeather;
    return GestureDetector(
      // This is to enable the keyboard to disappear when tapping outside of it.
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
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
            child: _body(),
          )),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
