import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weathery/models/weathermodel.dart';
import 'package:intl/intl.dart';
import 'package:weathery/pages/widgets/wind-direction.dart';
import 'package:weathery/utils/stringextensions.dart';

class WeatherForecast extends StatefulWidget {
  // const WeatherForecast({ Key? key }) : super(key: key);
  final WeatherForecastResponse weatherForecastResponse;

  WeatherForecast({required this.weatherForecastResponse});

  @override
  _WeatherForecastState createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {
  Map<int, bool> isExpandedMap = {0: true};

  Widget _temperatureText(double temp, double feelsLike) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(temp.toString().formatCelcius()),
        Text('(${feelsLike.toString().formatCelcius()})')
      ],
    );
  }

  Widget _createExpansionListPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          isExpandedMap = {index: !isExpanded};
        });
      },
      children: widget.weatherForecastResponse.forecast
          .map<ExpansionPanel>((DailyWeather daily) {
        var curIndex = widget.weatherForecastResponse.forecast.indexOf(daily);
        return ExpansionPanel(
          isExpanded: isExpandedMap[curIndex] ?? false,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return _header(daily);
          },
          body: _body(daily),
        );
      }).toList(),
    );
  }

  Widget _header(DailyWeather daily) {
    var day = DateFormat.EEEE().format(daily.dt);
    var date = DateFormat('d/M').format(daily.dt);
    var iconUrl = daily.weather.first.icon.isNotEmpty
        ? 'http://openweathermap.org/img/wn/${daily.weather.first.icon}@2x.png'
        : '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day.substring(0, 3),
              style: TextStyle(fontSize: 10),
            ),
            Text(
              date,
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
        iconUrl.isEmpty
            ? Icon(Icons.circle)
            : Image.network(
                iconUrl,
                width: 45,
                height: 45,
              ),
        Text(
          '${daily.rain}mm',
          style: TextStyle(
            color: daily.rain > 0 ? Colors.black : Colors.black26,
            fontSize: 10,
          ),
        ),
        WindDirection(
          angle: daily.windDeg,
          windGust: daily.windGust,
          windSpeed: daily.windSpeed,
        ),
      ],
    );
  }

  Widget _body(DailyWeather daily) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 1.0,
      children: [
        Card(
          margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                child: Text(
                  '${daily.weather.first.main} (${daily.weather.first.description})',
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(daily.temp.max.toString().formatCelcius(),
                      style: TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color: Colors.black38,
                      )),
                  Text('(${daily.temp.min.toString().formatCelcius()})',
                      style: TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color: Colors.black38,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Icon(
                          Icons.wb_sunny,
                          semanticLabel: 'Up',
                          size: 12,
                        ),
                        Text(
                          '${DateFormat('hh:mm').format(
                            daily.sunrise.add(
                              Duration(seconds: 7200),
                            ),
                          )}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Icon(
                          Icons.wb_twilight,
                          semanticLabel: 'Down',
                          size: 12,
                        ),
                        Text(
                          '${DateFormat('hh:mm').format(
                            daily.sunset.add(
                              Duration(seconds: 7200),
                            ),
                          )}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              DataTable(
                headingTextStyle: TextStyle(fontSize: 10, color: Colors.black),
                dataTextStyle: TextStyle(
                  fontSize: 9,
                  color: Colors.black,
                ),
                columns: [
                  DataColumn(
                    label: Row(
                      children: [
                        Icon(
                          Icons.thermostat,
                          size: 10,
                        ),
                        Text(
                          'Morning',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataColumn(
                      label: Text(
                    'Day',
                    style: TextStyle(fontSize: 10),
                  )),
                  DataColumn(
                      label: Text(
                    'Evening',
                    style: TextStyle(fontSize: 10),
                  )),
                  DataColumn(
                    label: Text(
                      'Night',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        _temperatureText(daily.temp.morn, daily.feelsLike.morn),
                      ),
                      DataCell(
                        _temperatureText(daily.temp.day, daily.feelsLike.day),
                      ),
                      DataCell(
                        _temperatureText(daily.temp.eve, daily.feelsLike.eve),
                      ),
                      DataCell(
                        _temperatureText(
                            daily.temp.night, daily.feelsLike.night),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _createExpansionListPanel(),
    );
    // return Expanded(
    //   child: ListView.builder(
    //     itemCount: widget.weatherForecastResponse.forecast.length,
    //     shrinkWrap: true,
    //     itemBuilder: (context, index) {
    //       return _createForecastCard(index);
    //     },
    //   ),
    // );
  }
}
