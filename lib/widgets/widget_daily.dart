import 'package:flutter/material.dart';
import 'package:outfitcast/data/data_daily.dart';
import 'package:weather/weather.dart';

class DailyWidget extends StatelessWidget {
  final String city;
  final DailyData dailyData;

  const DailyWidget({super.key, required this.city, required this.dailyData});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth * 0.21;
    final itemHeight = screenWidth * 0.4;

    return FutureBuilder<List<Weather>>(
      future: dailyData.loadDailyData(city),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError) {
            return _buildError('Failed to load daily forecast data');
          } else {
            final dailyForecast = snapshot.data;

            if (dailyForecast == null || dailyForecast.isEmpty) {
              return _buildError('Daily forecast data is empty');
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _buildDailyForecastCards(dailyForecast, itemWidth, itemHeight),
                ),
              );
            }
          }
        }
      },
    );
  }

  List<Widget> _buildDailyForecastCards(List<Weather> dailyForecast, double width, double height) {
    final now = DateTime.now();
    Map<int, Weather> forecastByDay = {};

    for (final forecast in dailyForecast) {
      if (forecast.date!.day != now.day) {
        final dayOfWeek = forecast.date!.weekday;
        if (!forecastByDay.containsKey(dayOfWeek)) {
          forecastByDay[dayOfWeek] = forecast;
        }
      }
    }

    return forecastByDay.entries.map((entry) {
      return _buildDailyCard(entry.value, width, height);
    }).toList();
  }

  Widget _buildDailyCard(Weather forecast, double width, double height) {
    String? imageUrl = _getWeatherImageUrl(forecast.weatherIcon);
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF30343B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _getDayOfWeek(forecast.date!),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          imageUrl != null ? Image.asset(
            imageUrl,
            width: 50,
            height: 50,
          ) : const SizedBox(),
          const SizedBox(height: 10),
          Text(
            "${forecast.temperature?.celsius?.toStringAsFixed(0)}°",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String? _getWeatherImageUrl(String? weatherIcon) {
    Map<String, String> weatherImages = {
      '01d': 'assets/forecast/sun/26.png', // ясно (днем)
      '01n': 'assets/forecast/sun/26.png', // ясно (ночью)

      '02d': 'assets/forecast/sun/4.png', // малооблачно (днем)
      '02n': 'assets/forecast/sun/4.png', // малооблачно (ночью)

      '03d': 'assets/forecast/sun/27.png', // облачно (днем)
      '03n': 'assets/forecast/sun/27.png', // облачно (ночью)

      '04d': 'assets/forecast/sun/4.png', // облачно с прояснениями (днем)
      '04n': 'assets/forecast/sun/4.png', // облачно с прояснениями (ночью)

      '09d': 'assets/forecast/sun/8.png', // легкий дождь (днем)
      '09n': 'assets/forecast/sun/8.png', // легкий дождь (ночью)

      '10d': 'assets/forecast/sun/8.png', // дождь (днем)
      '10n': 'assets/forecast/sun/8.png', // дождь (ночью)

      '11d': 'assets/forecast/sun/30.png', // гроза (днем)
      '11n': 'assets/forecast/sun/30.png', // гроза (ночью)

      '13d': 'assets/forecast/snow/36.png', // снег (днем)
      '13n': 'assets/forecast/snow/36.png', // снег (ночью)

      '50d': 'assets/forecast/mist/mist.png', // туман (днем)
      '50n': 'assets/forecast/mist/mist.png', // туман (ночью)
    };

    return weatherImages[weatherIcon ?? ''];
  }

  Widget _buildError(String message) {
    return Center(
      child: Text('Error: $message'),
    );
  }

  String _getDayOfWeek(DateTime date) {
    List<String> daysOfWeek = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return daysOfWeek[date.weekday - 1];
  }
}
