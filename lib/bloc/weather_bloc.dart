import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_app_test/model/weather_model.dart';
import 'package:flutter_app_test/api/weather_api.dart';
import 'package:flutter_app_test/bloc/weather_event.dart';
import 'package:flutter_app_test/bloc/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherAPI weatherAPI;

  WeatherBloc({@required this.weatherAPI}) : assert(weatherAPI != null);

  @override
  WeatherState get initialState {
    return WeatherEmpty();
  }

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield WeatherLoading();
      try {
        final Weather weather = await weatherAPI.getWeather(
            event.cityName, event.latitude, event.longitude);
        yield WeatherLoaded(weather: weather);
      } catch (exception) {
        print(exception);
        yield WeatherError(errorCode: 500);
      }
    }
  }
}
