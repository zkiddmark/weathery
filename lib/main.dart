import 'package:flutter/material.dart';
import 'package:weathery/pages/loading.dart';
import 'package:weathery/pages/weather.dart';
import 'package:weathery/services/inherited-weather-service.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    await InheritedWeatherServiceContainer.builder(
      navigatorKey: navigatorKey,
      child: MaterialApp(
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Color(0xff1976d2),
          primaryColorDark: Color(0xff004ba0),
          primaryColorLight: Color(0xff63a4ff),
          accentColor: Color(0xffc62828),
          dividerColor: Colors.grey[400],
          errorColor: Colors.red[800],

          // Define the default font family.
          fontFamily: 'Roboto',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 10.0),
          ),
        ),
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        navigatorKey: navigatorKey,
        initialRoute: '/loading',
        routes: {
          '/loading': (BuildContext context) => Loading(),
          '/weather': (BuildContext context) => Weather()
        },
      ),
    ),
  );
}
