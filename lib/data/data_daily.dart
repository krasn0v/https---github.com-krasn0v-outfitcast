import 'package:weather/weather.dart';

class DailyData {
  List<Weather>? _dailyData;
  Map<String, double>? _dailyAverages;
  final String apiKey;

  DailyData({required this.apiKey});

  Future<List<Weather>> loadDailyData(String city) async {
    WeatherFactory weatherFactory = WeatherFactory(apiKey);

    List<Weather> forecasts = await weatherFactory.fiveDayForecastByCityName(city);
    if (forecasts.isNotEmpty) {
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      DateTime endOfDay = DateTime(now.year, now.month, now.day + 6);
      _dailyData = forecasts.where((forecast) {
        DateTime forecastDate = forecast.date!;
        return forecastDate.isAfter(startOfDay) && forecastDate.isBefore(endOfDay);
      }).toList();
      _dailyAverages = _calculateDailyAverages(_dailyData!);
      return _dailyData!;
    } else {
      _dailyData = null;
      _dailyAverages = null;
      return [];
    }
  }

  List<Weather>? getDailyForecast() {
    return _dailyData;
  }

  Map<String, double>? getDailyAverages() {
    return _dailyAverages;
  }

  Map<String, double> _calculateDailyAverages(List<Weather> dailyForecasts) {
    Map<String, List<double>> dailyTemperatures = {};

    for (var forecast in dailyForecasts) {
      String day = _getDayOfWeek(forecast.date!);
      double temperature = forecast.temperature!.celsius!;

      dailyTemperatures.putIfAbsent(day, () => []).add(temperature);
    }

    Map<String, double> dailyAverages = {};
    dailyTemperatures.forEach((day, temperatures) {
      double averageTemperature = temperatures.reduce((a, b) => a + b) / temperatures.length;
      dailyAverages[day] = double.parse(averageTemperature.toStringAsFixed(2));
    });

    return dailyAverages;
  }

  String _getDayOfWeek(DateTime date) {
    List<String> daysOfWeek = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return daysOfWeek[date.weekday - 1];
  }
}


