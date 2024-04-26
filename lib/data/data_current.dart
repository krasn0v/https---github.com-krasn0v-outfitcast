import 'package:weather/weather.dart';

class CurrentData {
  final String apiKey;
  Weather? _currentWeather;

  CurrentData({required this.apiKey});

  Future<void> loadCurrentData(String city) async {
    try {
      WeatherFactory weatherFactory = WeatherFactory(apiKey);
      _currentWeather = await weatherFactory.currentWeatherByCityName(city);
    } catch (e) {
      print('Error loading current weather data: $e');
    }
  }

  double? getPressure() {
    return _currentWeather?.pressure;
  }

  double? getPressureInMmHg() {
    final pressureInHPa = _currentWeather?.pressure;
    if (pressureInHPa != null) {
      const double hPaToMmHg = 0.75006375541921;
      return pressureInHPa * hPaToMmHg;
    }
    return null;
  }

  double? getTemperature() {
    return _currentWeather?.temperature?.celsius;
  }

  double? getHumidity() {
    return _currentWeather?.humidity;
  }

  double? getWindSpeed() {
    return _currentWeather?.windSpeed;
  }

  String? getWeatherIcon() {
    return _currentWeather?.weatherIcon;
  }

}




