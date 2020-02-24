import 'package:flutter/material.dart';
import 'package:flutter_app_test/api/api_key.dart';
import 'package:flutter_app_test/api/weather_api.dart';
import 'package:flutter_app_test/widgets/weather_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_app_test/bloc/weather_bloc.dart';
import 'package:flutter_app_test/bloc/weather_event.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_test/bloc/weather_state.dart';

class WeatherScreen extends StatefulWidget {
  final WeatherAPI weatherAPI =
      WeatherAPI(httpClient: http.Client(), apiKey: APIKey.WEATHER_APP_API);
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  WeatherBloc _weatherBloc;
  String _nameOfTheCity = 'Los Angeles';

  AnimationController _fadeController;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _weatherBloc = WeatherBloc(weatherAPI: widget.weatherAPI);
    _fetchWeatherWithLocation().catchError((error) {
      _fetchWeatherWithCity();
    });

    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Weather App',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
        ),
      ),
      body: Material(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(color: Colors.black),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: BlocBuilder(
              bloc: _weatherBloc,
              builder: (_, WeatherState weatherState) {
                if (weatherState is WeatherLoaded) {
                  this._nameOfTheCity = weatherState.weather.cityName;
                  _fadeController.reset();
                  _fadeController.forward();
                  return WeatherWidget(
                    weather: weatherState.weather,
                  );
                } else if (weatherState is WeatherError ||
                    weatherState is WeatherEmpty) {
                  String errorText = 'There was an error fetching weather data';
                  if (weatherState is WeatherError) {
                    if (weatherState.errorCode == 404) {
                      errorText =
                          'We have trouble fetching weather for $_nameOfTheCity';
                    }
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 24,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        errorText,
                        style: TextStyle(color: Colors.white),
                      ),
                      FlatButton(
                        child: Text(
                          "Try Again",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _fetchWeatherWithCity,
                      )
                    ],
                  );
                } else if (weatherState is WeatherLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  _fetchWeatherWithLocation() async {
    var permissionHandler = PermissionHandler();
    var permissionResult = await permissionHandler
        .requestPermissions([PermissionGroup.locationWhenInUse]);

    switch (permissionResult[PermissionGroup.locationWhenInUse]) {
      case PermissionStatus.denied:
      case PermissionStatus.unknown:
        _showLocationDeniedDialog(permissionHandler);
        throw Error();
    }

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    _weatherBloc.dispatch(FetchWeather(
        longitude: position.longitude, latitude: position.latitude));
  }

  _fetchWeatherWithCity() {
    _weatherBloc.dispatch(FetchWeather(cityName: _nameOfTheCity));
  }

  void _showLocationDeniedDialog(PermissionHandler permissionHandler) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Location is disabled :(',
                style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Enable!',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
                onPressed: () {
                  permissionHandler.openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
