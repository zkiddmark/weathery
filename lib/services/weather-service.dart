import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:weathery/models/weathermodel.dart';
import 'package:weathery/services/geolocator-service.dart';

class WeatherService {
  late GeoLocatorService geoLocatorService;

  final String apiKey = 'c69ee9e3c9d96a1116880c95c88ddea2';
  // final String baseUrl =
  //     'https://api.openweathermap.org/data/2.5/weather?appid=c69ee9e3c9d96a1116880c95c88ddea2&units=metric';

  // late WeatherResponse currentWeather;
  late WeatherForecastResponse? forecast;

  List<GeocodingResponse> geoCodingList = List.empty();
  late GeocodingResponse geoCoding;
  late GeocodingResponse currentLocation;
  StreamController<bool> fetchingData = StreamController.broadcast();

  Future<void> initGeoLocatorService() async {
    this.geoLocatorService = await GeoLocatorService.create();
  }

  Future<void> getGeolocationsByLocation(String location,
      {int limit = 10}) async {
    var url = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$location&limit=$limit&appid=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body) as List<dynamic>;
      geoCodingList =
          res.map((location) => GeocodingResponse.fromJson(location)).toList();
    } else if (response.statusCode >= 300) {
      throw HttpException(
          'Unable to fetch GeoLocations!, Status: ${response.statusCode}',
          uri: url);
    } else {
      throw Exception('There was a unexpected error while fetching geodata.');
    }
  }

  // Future<void> getCoordinatesByLocation(String location,
  //     {int limit = 1}) async {
  //   var url = Uri.parse(
  //       'http://api.openweathermap.org/geo/1.0/direct?q=$location&limit=$limit&appid=$apiKey');
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var res = jsonDecode(response.body) as List<dynamic>;
  //     geoCoding = GeocodingResponse.fromJson(res.first);
  //     // print(geoCoding);
  //     await getWeather(geoCoding);
  //   } else if (response.statusCode >= 300) {
  //     throw HttpException(
  //         'Unable to fetch GeoLocations!, Status: ${response.statusCode}',
  //         uri: url);
  //   } else {
  //     throw Exception('There was a unexpected error while fetching geodata.');
  //   }
  // }

  Future<void> getLocationByGeoServiceCoordinates() async {
    fetchingData.add(true);
    await _getLocationByCoordinates(geoLocatorService.currentPosition.latitude,
        geoLocatorService.currentPosition.longitude);
    fetchingData.add(false);
  }

  Future<void> _getLocationByCoordinates(double lat, double lon,
      {int limit = 1}) async {
    var url = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&limit=$limit&appid=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body) as List<dynamic>;
      geoCoding = GeocodingResponse.fromJson(res.first);
      currentLocation =
          GeocodingResponse.fromJson(res.first); // Sets the current location.
      // print(geoCoding);
      await _getWeatherForecast(geoCoding.lat, geoCoding.lon);
    } else if (response.statusCode >= 300) {
      throw HttpException(
          'Unable to fetch GeoLocations!, Status: ${response.statusCode}',
          uri: url);
    } else {
      throw Exception('There was a unexpected error while fetching geodata.');
    }
  }

  Future<void> getWeather(GeocodingResponse location) async {
    try {
      fetchingData.add(true);
      geoCoding = location;
      await _getWeatherForecast(location.lat, location.lon);
    } catch (e) {
      rethrow;
    } finally {
      fetchingData.add(false);
    }
  }

  Future<void> _getWeatherForecast(double lat, double lon) async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=hourly,minutely,current&appid=$apiKey&units=metric');
    // print(url);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // print(response.body);
      forecast = WeatherForecastResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode >= 300) {
      throw HttpException(
          'Unable to fetch weather!, Status: ${response.statusCode}',
          uri: url);
    } else {
      throw Exception(
          'There was a unexpected error while fetching weatherdata.');
    }
  }

  static Future<WeatherService> create() async {
    var service = WeatherService();
    return service;
  }
}
