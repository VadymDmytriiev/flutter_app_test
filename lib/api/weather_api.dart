import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app_test/model/weather_model.dart';

class WeatherAPI {
  final apiKey;
  static const baseURL = 'http://api.openweathermap.org';
  final http.Client httpClient;

  WeatherAPI({this.apiKey, this.httpClient});

  Future<String> getCityNameWithLocation({double latitude, double longitude}) async {
    final url = '$baseURL/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey';
    final res = await this.httpClient.get(url);
    if (res.statusCode != 200) {
      print(res.statusCode);
    }
    final weatherJson = json.decode(res.body);

    return weatherJson['name'];
  }

  Future<Weather> getWeather(String cityName, double latitude, double longitude) async {
    if (cityName == null) {
        cityName = await getCityNameWithLocation(latitude: latitude, longitude: longitude);
    }
    var weather = await getWeatherData(cityName);
    var weathers = await getWeatherForecast(cityName);
    weather.forecast = weathers;
    return weather;
  }

  Future<Weather> getWeatherData(String cityName) async {
    final url = '$baseURL/data/2.5/weather?q=$cityName&appid=$apiKey';
    final res = await this.httpClient.get(url);
    if (res.statusCode != 200) {
      print('Failed to fetch data');
    }
    final weatherJson = json.decode(res.body);
    return Weather.fromJson(weatherJson);
  }

  Future<List<Weather>> getWeatherForecast(String cityName) async {
    final url = '$baseURL/data/2.5/forecast?q=$cityName&appid=$apiKey';
    final res = await this.httpClient.get(url);
    if (res.statusCode != 200) {
      print("Failed to fetch data");    }
    final forecastJson = json.decode(res.body);
    List<Weather> weathers = Weather.fromForecastJson(forecastJson);
    return weathers;
  }

}