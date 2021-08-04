import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weathery/models/weathermodel.dart';
import 'package:weathery/pages/widgets/forecast.dart';
import 'package:weathery/pages/widgets/search-location.dart';
import 'package:weathery/pages/widgets/overlay-spinner.dart';
import 'package:weathery/services/inherited-weather-service.dart';
import 'package:weathery/services/weather-service.dart';

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  late WeatherForecastResponse? _weather;
  List<GeocodingResponse> _geCodingList = List.empty();
  late WeatherService _weatherService;
  late OverlaySpinner _spinner;
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weatherService = WeatherServiceContainer.of(context);
    _initSpinnerSubscription();
  }

  Future<void> searchLocations(String location) async {
    try {
      await _weatherService.getGeolocationsByLocation(location);
      _textEditingController.clear();
      setState(() {
        _geCodingList = _weatherService.geoCodingList;
      });
    } catch (e) {
      // print((e as TypeError).stackTrace);
      var text = e is HttpException ? e.message : 'Something went wrong';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> updateWeatherLocation(GeocodingResponse location) async {
    try {
      await _weatherService.getWeather(location);
      _textEditingController.clear();
      setState(() => {_weather = _weatherService.forecast});
    } catch (e) {
      print(e);
      var text = e is HttpException ? e.message : 'Something went wrong';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> getWeatherFromCurrentLocation() async {
    try {
      // await _weatherService.initGeoLocatorService();
      await _weatherService.getLocationByGeoServiceCoordinates(); // fixa

      setState(() => {_weather = _weatherService.forecast});
    } catch (e) {
      print(e);
      var text = e is HttpException ? e.message : 'Something went wrong';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  _initSpinnerSubscription() {
    _spinner =
        OverlaySpinner.create(_weatherService.fetchingData.stream, context);
    _spinner.setupSubscription(setState);
  }

  _body() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/main-background.jpeg'),
          // image: NetworkImage(
          //   'https://images.unsplash.com/photo-1581150257735-1c93ea8306ef?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
          // ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SearchLocation(
            //   focusNode: _focusNode,
            //   textEditingController: _textEditingController,
            //   callbackFn: updateWeatherLocation,
            // ),
            // _searchField(context),
            Expanded(
              child: _weather != null
                  ? WeatherForecast(
                      weatherForecastResponse: _weather,
                    )
                  : Text('Please search for a location'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _weather = _weatherService.forecast;
    return GestureDetector(
      // This is to enable the keyboard to disappear when tapping outside of it.
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        drawerScrimColor: Colors.black12,
        resizeToAvoidBottomInset: false,
        endDrawer: _searchDrawer(context),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Weather for ${_weatherService.geoCoding.name} (${_weatherService.geoCoding.country})',
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.search),
                tooltip: 'Search location',
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            })
          ],
        ),
        body: _body(),
      ),
    );
  }

  Drawer _searchDrawer(BuildContext context) {
    var locationServiceEnabled =
        _weatherService.geoLocatorService.serviceEnabled;
    var currentLocation = _weatherService.currentLocation.name;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
            ),
            child: SearchLocation(
              focusNode: _focusNode,
              textEditingController: _textEditingController,
              callbackFn: searchLocations,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
            ),
            child: ListTile(
              title: Text(locationServiceEnabled
                  ? currentLocation
                  : 'Location service is not enabled on the device'),
              leading: Icon(Icons.pin_drop),
              enabled: locationServiceEnabled,
              onTap: () => {
                getWeatherFromCurrentLocation(),
                Navigator.of(context).pop()
              },
            ),
          ),
          Divider(
            color: Theme.of(context).dividerColor,
          ),
          ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            itemCount: _geCodingList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_geCodingList[index].name),
                subtitle: Text(_geCodingList[index].country),
                onTap: () => {
                  updateWeatherLocation(_geCodingList[index]),
                  Navigator.of(context).pop()
                },
                tileColor: Colors.blueGrey[index * 100],
              );
            },
          )
        ],
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
