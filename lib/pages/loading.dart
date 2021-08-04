import 'dart:io';
import 'package:flutter/material.dart';
import 'package:weathery/pages/weather.dart';
import 'package:weathery/pages/widgets/search-location.dart';
import 'package:weathery/pages/widgets/overlay-spinner.dart';
import 'package:weathery/services/inherited-weather-service.dart';
import 'package:weathery/services/weather-service.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  // bool _showSpinner = false;
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  late WeatherService _weatherService;
  late OverlaySpinner _spinner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weatherService = WeatherServiceContainer.of(context);
    setupSpinnerSubscription();
    loadWeather();
  }

  void setupSpinnerSubscription() {
    _spinner =
        OverlaySpinner.create(_weatherService.fetchingData.stream, context);
    _spinner.setupSubscription(setState);
  }

  void loadWeather() async {
    // ScaffoldMessenger.of(context)
    // .showSnackBar(SnackBar(content: Text('dsadas')));
    try {
      await _weatherService.initGeoLocatorService();
      if (_weatherService.geoLocatorService.serviceStatus) {
        await _weatherService.getLocationByGeoServiceCoordinates();
        initNavigation();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Location services are turned off',
          ),
        ),
      );
    }
  }

  void initNavigation() {
    Navigator.pushReplacement(context, _routeToWeather());
  }

  Route _routeToWeather() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Weather();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Future<void> updateWeatherLocation(String location) async {
    try {
      await _weatherService.getGeolocationsByLocation(location, limit: 1);
      await _weatherService.getWeather(_weatherService.geoCodingList.first);
      _textEditingController.clear();
      initNavigation();
      // setState(() => {_weather = _weatherService.forecast});
    } catch (e) {
      print(e);
      var text = e is HttpException ? e.message : 'Something went wrong';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // initNavigation();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Weathery'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('images/loading.jpeg'),
          ),
        ),
        child: SizedBox.expand(
          child: StreamBuilder<bool>(
              stream: _weatherService.fetchingData.stream,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
                    child: Text(
                      'Wait while fetching data',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  );
                }
                return SearchLocation(
                  focusNode: _focusNode,
                  textEditingController: _textEditingController,
                  callbackFn: updateWeatherLocation,
                );
              }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    _spinner.disposeSpinner();
    super.dispose();
  }
}
