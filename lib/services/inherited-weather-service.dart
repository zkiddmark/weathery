import 'package:flutter/material.dart';
import 'package:weathery/services/weather-service.dart';

class InheritedWeatherServiceContainer extends InheritedWidget {
  final WeatherService service;
  const InheritedWeatherServiceContainer(
      {Key? key, required this.service, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static Future<InheritedWeatherServiceContainer> builder(
      {required MaterialApp child, required Key navigatorKey}) async {
    var service = await WeatherService.create();
    // await service.getLocationByGeoServiceCoordinates();
    return InheritedWeatherServiceContainer(service: service, child: child);
  }
}

class WeatherServiceContainer extends StatefulWidget {
  final Widget child;
  const WeatherServiceContainer({Key? key, required this.child})
      : super(key: key);

  static WeatherService of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<
                InheritedWeatherServiceContainer>()
            as InheritedWeatherServiceContainer)
        .service;
  }

  @override
  _WeatherServiceContainerState createState() =>
      _WeatherServiceContainerState();
}

class _WeatherServiceContainerState extends State<WeatherServiceContainer> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
