import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:weathery/models/weathermodel.dart';
import 'package:weathery/services/geolocator-service.dart';

class WeatherService {
  late final GeoLocatorService geoLocatorService;

  final String apiKey = 'c69ee9e3c9d96a1116880c95c88ddea2';
  // final String baseUrl =
  //     'https://api.openweathermap.org/data/2.5/weather?appid=c69ee9e3c9d96a1116880c95c88ddea2&units=metric';

  late WeatherResponse currentWeather;
  late WeatherForecastResponse forecast;

  Future<void> getWeatherByCoordinates(double lat, double lon) async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?appid=$apiKey&units=metric&lat=$lat&lon=$lon');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      currentWeather = WeatherResponse.fromJson(jsonDecode(response.body));
      await getWeatherForecast(currentWeather.lat, currentWeather.lon);
    } else if (response.statusCode >= 300) {
      throw HttpException(
          'Unable to fetch weather!, Status: ${response.statusCode}',
          uri: url);
    } else {
      throw Exception(
          'There was a unexpected error while fetching weatherdata.');
    }
  }

  Future<void> getWeatherByLocation(String location) async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?appid=c69ee9e3c9d96a1116880c95c88ddea2&units=metric&q=$location');
    print(url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      currentWeather = WeatherResponse.fromJson(jsonDecode(response.body));
      await getWeatherForecast(currentWeather.lat, currentWeather.lon);
    } else if (response.statusCode >= 300) {
      throw HttpException(
          'Unable to fetch weather!, Status: ${response.statusCode}',
          uri: url);
    } else {
      throw Exception(
          'There was a unexpected error while fetching weatherdata.');
    }
  }

  Future<void> getWeatherForecast(double lat, double lon) async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=hourly,minutely,current&appid=$apiKey&units=metric');
    print(url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      currentWeather.forecast =
          WeatherForecastResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode >= 300) {
      throw HttpException(
          'Unable to fetch weather!, Status: ${response.statusCode}',
          uri: url);
    } else {
      throw Exception(
          'There was a unexpected error while fetching weatherdata.');
    }
  }

  void updateLocation(String location) async {
    print('Updating position');
    await getWeatherByLocation(location);
  }

  static Future<WeatherService> create() async {
    var service = WeatherService();
    service.geoLocatorService = await GeoLocatorService.create();
    return service;
  }
}

// class WeatherResponse {
//   final String name;
//   final double temp;
//   final List<Weather> weather;
//   final Wind wind;

//   WeatherResponse(this.name, this.temp, this.weather, this.wind);

//   factory WeatherResponse.fromJson(Map<String, dynamic> json) {
//     var parsedWeatherList = json['weather'] as List<dynamic>;

//     return WeatherResponse(
//         json['name'],
//         double.parse(json['main']['temp'].toString()),
//         // weather: Weather.fromJson(json['weather']);
//         parsedWeatherList.map((e) => Weather.fromJson(e)).toList(),
//         Wind.fromJson(json['wind']));
//   }
// }

// class Weather {
//   late final int id;
//   late final String main;
//   late final String description;
//   late final String icon;

//   Weather.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         main = json['main'],
//         description = json['description'],
//         icon = json['icon'];
// }

// class Wind {
//   late final double speed;
//   late final int deg;

//   Wind.fromJson(Map<String, dynamic> json)
//       : speed = json['speed'],
//         deg = json['deg'];
// }

/*
{
  "coord": {
    "lon": -122.08,
    "lat": 37.39
  },
  "weather": [
    {
      "id": 800,
      "main": "Clear",
      "description": "clear sky",
      "icon": "01d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 282.55,
    "feels_like": 281.86,
    "temp_min": 280.37,
    "temp_max": 284.26,
    "pressure": 1023,
    "humidity": 100
  },
  "visibility": 16093,
  "wind": {
    "speed": 1.5,
    "deg": 350
  },
  "clouds": {
    "all": 1
  },
  "dt": 1560350645,
  "sys": {
    "type": 1,
    "id": 5122,
    "message": 0.0139,
    "country": "US",
    "sunrise": 1560343627,
    "sunset": 1560396563
  },
  "timezone": -25200,
  "id": 420006353,
  "name": "Mountain View",
  "cod": 200
  }                         

 */