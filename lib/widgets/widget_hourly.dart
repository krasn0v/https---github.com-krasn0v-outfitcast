import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import '../data/data_hourly.dart';

class HourlyWidget extends StatefulWidget {
  final String city;
  final HourlyData hourlyData;

  const HourlyWidget({super.key, required this.city, required this.hourlyData});

  @override
  HourlyWidgetState createState() => HourlyWidgetState();
}

class HourlyWidgetState extends State<HourlyWidget> {
  late HourlyData hourlyData;
  late Map<String, String> weatherImages = {
    '01d': 'assets/forecast/sun/26.png', // ясно (днем)
    '01n': 'assets/forecast/moon/10.png', // ясно (ночью)

    '02d': 'assets/forecast/sun/4.png', // малооблачно (днем)
    '02n': 'assets/forecast/moon/31.png', // малооблачно (ночью)

    '03d': 'assets/forecast/sun/27.png', // облачно (днем)
    '03n': 'assets/forecast/moon/15.png', // облачно (ночью)

    '04d': 'assets/forecast/sun/4.png', // облачно с прояснениями (днем)
    '04n': 'assets/forecast/moon/31.png', // облачно с прояснениями (ночью)

    '09d': 'assets/forecast/sun/8.png', // легкий дождь (днем)
    '09n': 'assets/forecast/moon/1.png', // легкий дождь (ночью)

    '10d': 'assets/forecast/sun/8.png', // дождь (днем)
    '10n': 'assets/forecast/moon/1.png', // дождь (ночью)

    '11d': 'assets/forecast/sun/30.png', // гроза (днем)
    '11n': 'assets/forecast/moon/20.png', // гроза (ночью)

    '13d': 'assets/forecast/snow/36.png', // снег (днем)
    '13n': 'assets/forecast/snow/36.png', // снег (ночью)

    '50d': 'assets/forecast/mist/mist.png', // туман (днем)
    '50n': 'assets/forecast/mist/mist.png', // туман (ночью)
  };

  @override
  void initState() {
    super.initState();
    hourlyData = widget.hourlyData;
    _loadHourlyData(widget.city);
  }

  void _loadHourlyData(String city) async {
    await hourlyData.loadHourlyData(city);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth * 0.21;
    final itemHeight = screenWidth * 0.4;

    return FutureBuilder<void>(
      future: hourlyData.loadHourlyData(widget.city),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError) {
            return _buildError('Failed to load hourly forecast data');
          } else {
            final hourlyForecast = hourlyData.getHourlyForecast();

            if (hourlyForecast == null || hourlyForecast.isEmpty) {
              return _buildError('Hourly forecast data is empty');
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: hourlyForecast.map((forecast) {
                    return _buildHourlyCard(forecast, itemWidth, itemHeight);
                  }).toList(),
                ),
              );
            }
          }
        }
      },
    );
  }

  Widget _buildHourlyCard(Weather forecast, double width, double height) {
    String? imageUrl = weatherImages[forecast.weatherIcon ?? ''];
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
            "${forecast.date?.hour}:00",
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
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Text('Error: $message'),
    );
  }
}

