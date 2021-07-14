import 'package:flutter/material.dart';
import 'package:weathery/models/weathermodel.dart';
import 'package:weathery/pages/widgets/forecast.dart';
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

  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  void updateWeatherLocation(String location) async {
    var ws = weatherService['data'] as WeatherService;
    await ws.getWeatherByLocation(location);
    _textEditingController.clear();
    setState(() => {weather = ws.currentWeather});
  }

  _searchField(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextField(
        focusNode: _focusNode,
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
          _focusNode.unfocus()
        },
      ),
    );
  }

  _body() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            'https://images.unsplash.com/photo-1581150257735-1c93ea8306ef?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _searchField(context),
            Expanded(
              child: WeatherForecast(
                weatherForecastResponse: weather.forecast,
              ),
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
        body: _body(),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
