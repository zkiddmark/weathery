import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'c69ee9e3c9d96a1116880c95c88ddea2';
  final String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather?appid=c69ee9e3c9d96a1116880c95c88ddea2&units=metric';

  Future<WeatherResponse> getWeatherByCoordinates(
      double lat, double lon) async {
    var url = Uri.parse('$baseUrl&lat=$lat&lon=$lon');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return WeatherResponse.fromJson(jsonDecode(response.body));
    } else {
      throw HttpException('Unable to fetch weather!');
    }
  }
}

class WeatherResponse {
  final String name;
  final double temp;
  final List<Weather> weather;

  WeatherResponse(this.name, this.temp, this.weather);

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    var parsedWeatherList = json['weather'] as List<dynamic>;

    return WeatherResponse(
        json['name'],
        double.parse(json['main']['temp'].toString()),
        // weather: Weather.fromJson(json['weather']);
        parsedWeatherList.map((e) => Weather.fromJson(e)).toList());
  }
}

class Weather {
  late final int id;
  late final String main;
  late final String description;
  late final String icon;

  Weather.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        main = json['main'],
        description = json['description'],
        icon = json['icon'];
  // Weather.fromJson(List<dynamic> arr) {
  //   arr.forEach((json) {
  //     id = json['id'];
  //     main = json['main'];
  //     description = json['description'];
  //     icon = json['icon'];
  //   });
  // }
}


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