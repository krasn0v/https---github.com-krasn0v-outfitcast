import 'package:flutter/material.dart';
import 'package:outfitcast/data/data_current.dart';

class CurrentWidget extends StatelessWidget {
  final String city;
  final CurrentData currentWeather;

  const CurrentWidget({
    super.key,
    required this.city,
    required this.currentWeather,
  });

  @override
  Widget build(BuildContext context) {
    String? weatherIcon = currentWeather.getWeatherIcon();
    String? imageUrl = _getWeatherImageUrl(weatherIcon);

    return Expanded(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF59A1F5),
                  Color(0xFF2C19A3),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${currentWeather.getTemperature()?.round()}°',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 100,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1,
                            letterSpacing: -8.0,
                          ),
                        ),
                        Text(
                          'Ощущается как ${currentWeather.getTemperature()?.round()}°',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/humidity.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${currentWeather.getHumidity()?.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/pressure.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${currentWeather.getPressureInMmHg()?.toStringAsFixed(0)} мм. рт. ст.',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/wind.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${currentWeather.getWindSpeed()?.toStringAsFixed(0)} м/с',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Image.asset(
              imageUrl ?? 'assets/default_image.png',
              width: 120,
              height: 120,
            ),
          ),
        ],
      ),
    );
  }

  String? _getWeatherImageUrl(String? weatherIcon) {
    Map<String, String> weatherImages = {
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

    return weatherImages[weatherIcon ?? ''];
  }
}