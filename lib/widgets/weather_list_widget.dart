import 'package:flutter/material.dart';
import 'package:flutter_app_test/utils/units_converter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app_test/widgets/forecast_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_test/model/weather_model.dart';

class WeatherHorizontal extends StatelessWidget {
  const WeatherHorizontal({
    Key key,
    @required this.weather,
  }) : super(key: key);

  final List<Weather> weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 5,
        separatorBuilder: (context, index) => Divider(
          height: 100,
          color: Colors.white,
        ),
        padding: EdgeInsets.only(left: 10, right: 10),
        itemBuilder: (context, index) {
          final item = this.weather[index];
          return Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Center(
                child: ValueTile(
              DateFormat('E, ha').format(
                  DateTime.fromMillisecondsSinceEpoch(item.time * 1000)),
              '${UnitsContverter.convertKelvinToCelsius(item.temperature).round()}°',
              iconData: item.getIconData(),
            )),
          );
        },
      ),
    );
  }
}
