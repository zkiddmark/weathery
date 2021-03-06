import 'package:weathery/utils/datetimeextensions.dart';
import 'package:weathery/utils/stringextensions.dart';

class GeocodingResponse {
  final String name;
  final String country;
  final double lat;
  final double lon;

  GeocodingResponse.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        country = json['country'],
        lat = double.parse(json['lat'].toString()),
        lon = double.parse(json['lon'].toString());
}

class WeatherForecastResponse {
  final double lat;
  final double lon;
  final String timezone;
  final int timezoneOffset;
  final List<DailyWeather> forecast;

  WeatherForecastResponse.fromJson(Map<String, dynamic> json)
      : lat = json['lat'],
        lon = json['lon'],
        timezone = json['timezone'],
        timezoneOffset = json['timezone_offset'],
        forecast = DailyWeather.fromDynamic(json['daily']);
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

  static List<Weather> fromDynamic(List<dynamic> json) {
    return json.map((e) => Weather.fromJson(e)).toList();
  }
}

class Wind {
  late final double speed;
  late final double deg;
  late final double gust;

  Wind.fromJson(Map<String, dynamic> json)
      : speed = double.parse(json['speed'].toString()),
        deg = double.parse(json['deg'].toString()),
        gust = json['gust'] ?? 0.0;
}

class DailyWeather {
  late final DateTime dt;
  late final DateTime sunrise;
  late final DateTime sunset;
  late final DailyTemp temp;
  late final DailyTemp feelsLike;
  late final double windSpeed;
  late final double windDeg;
  late final double windGust;
  late final List<Weather> weather;
  late final double rain;
  late final double clouds;

  DailyWeather.fromJson(Map<String, dynamic> json)
      : dt = DateTimeExtensions.fromUnixTimeStampToUtc(json['dt']),
        sunrise = DateTimeExtensions.fromUnixTimeStampToUtc(json['sunrise']),
        sunset = DateTimeExtensions.fromUnixTimeStampToUtc(json['sunset']),
        temp = DailyTemp.fromJson(json['temp']),
        feelsLike = DailyTemp.fromJson(json['feels_like']),
        windSpeed = double.parse(json['wind_speed'].toString()),
        windDeg = double.parse(json['wind_deg'].toString()),
        windGust = double.parse(json['wind_gust'].toString()),
        weather = Weather.fromDynamic(json['weather']),
        rain = double.tryParse(json['rain'].toString()) ?? 0.0,
        clouds = double.parse(json['clouds'].toString());

  static List<DailyWeather> fromDynamic(List<dynamic> json) {
    return json.map((e) => DailyWeather.fromJson(e)).toList();
  }
}

class DailyTemp {
  late final double day;
  late final double min;
  late final double max;
  late final double night;
  late final double eve;
  late final double morn;

  DailyTemp.fromJson(Map<String, dynamic> json)
      : day = json['day'].toString().parseTemp(),
        min = json['min'].toString().parseTemp(),
        max = json['max'].toString().parseTemp(),
        night = json['night'].toString().parseTemp(),
        eve = json['eve'].toString().parseTemp(),
        morn = json['morn'].toString().parseTemp();
}

/*daily: [
            {
            "dt": 1626199200,
            "sunrise": 1626174969,
            "sunset": 1626226039,
            "moonrise": 1626187080,
            "moonset": 1626236220,
            "moon_phase": 0.12,
            "temp": {
                "day": 304.85,
                "min": 293.97,
                "max": 305.05,
                "night": 297.37,
                "eve": 301.09,
                "morn": 294.09
            },
            "feels_like": {
                "day": 306.53,
                "night": 297.65,
                "eve": 302.73,
                "morn": 294.67
            },
            "pressure": 1021,
            "humidity": 48,
            "dew_point": 292.59,
            "wind_speed": 2.11,
            "wind_deg": 240,
            "wind_gust": 4.01,
            "weather": [
                {
                    "id": 800,
                    "main": "Clear",
                    "description": "clear sky",
                    "icon": "01d"
                }
            ],
            "clouds": 0,
            "pop": 0.02,
            "uvi": 10.23
        },
 */