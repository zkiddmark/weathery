import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weathery/models/weathermodel.dart';
import 'package:intl/intl.dart';
import 'package:weathery/pages/widgets/wind-direction.dart';

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
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          WindDirection(angle: todaysWeather.windDeg),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Min Temp: ${todaysWeather.temp.min}'),
              Text('Max Temp: ${todaysWeather.temp.max}'),
              Text('Morning Temp: ${todaysWeather.temp.morn}'),
              Text('Day Temp: ${todaysWeather.temp.day}'),
              Text('Evening Temp: ${todaysWeather.temp.eve}'),
              Text('Night Temp: ${todaysWeather.temp.night}'),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
