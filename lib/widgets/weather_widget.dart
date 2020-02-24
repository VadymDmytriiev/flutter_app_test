import 'package:flutter/material.dart';
import 'package:flutter_app_test/utils/units_converter.dart';
import 'package:flutter_app_test/widgets/weather_list_widget.dart';
import 'package:flutter_app_test/model/weather_model.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weather;

  WeatherWidget({this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            this.weather.cityName,
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
          SizedBox(height: 30),
          Text(
            this.weather.description[0].toUpperCase() +
                this.weather.description.substring(1),
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    height: MediaQuery.of(context).size.width * 0.50,
                    child: Icon(
                      weather.getIconData(),
                      color: Colors.white,
                      size: 80,
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    height: MediaQuery.of(context).size.width * 0.50,
                    child: Container(
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          '${UnitsContverter.convertKelvinToCelsius(this.weather.temperature).round()}°',
                          style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.w100,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          WeatherHorizontal(weather: weather.forecast),
        ],
      ),
    );
  }
}
