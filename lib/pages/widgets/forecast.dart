import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weathery/models/weathermodel.dart';
import 'package:intl/intl.dart';

class WeatherForecast extends StatelessWidget {
  // const WeatherForecast({ Key? key }) : super(key: key);
  final WeatherForecastResponse weatherForecastResponse;

  WeatherForecast({required this.weatherForecastResponse});

  _createForecastCard(int index) {
    var todaysWeather = weatherForecastResponse.forecast[index];
    var day = DateFormat.EEEE().format(todaysWeather.dt);
    var date = DateFormat('d/M').format(todaysWeather.dt);
    // ignore: unnecessary_null_comparison
    var iconUrl = todaysWeather.weather.first.icon != null
        ? 'http://openweathermap.org/img/wn/${todaysWeather.weather.first.icon}@2x.png'
        : 'local';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        key: UniqueKey(),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(day.substring(0, 3)),
              Text(date),
            ],
          ),
          iconUrl == 'local'
              ? Icon(Icons.circle)
              : Image.network(
                  iconUrl,
                  width: 50,
                  height: 50,
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: weatherForecastResponse.forecast.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _createForecastCard(index);
        },
      ),
    );
  }
}
