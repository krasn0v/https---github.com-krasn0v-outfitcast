import 'package:weather/weather.dart';
import 'package:outfitcast/api/api_key.dart';

class HourlyData {
  List<Weather>? _hourlyData;

  HourlyData({required String apiKey});

  Future<void> loadHourlyData(String city) async {
    WeatherFactory weatherFactory = WeatherFactory(API_KEY);

    List<Weather> forecasts = await weatherFactory.fiveDayForecastByCityName(city);
    if (forecasts.isNotEmpty) {
      DateTime now = DateTime.now();
      DateTime endOf27Hours = now.add(const Duration(hours: 27));
      _hourlyData = forecasts.where((forecast) {
        DateTime forecastDate = forecast.date!;
        return forecastDate.isAfter(now) && forecastDate.isBefore(endOf27Hours);
      }).toList();
    } else {
      _hourlyData = null;
    }
  }

  List<Weather>? getHourlyForecast() {
    return _hourlyData;
  }
}

