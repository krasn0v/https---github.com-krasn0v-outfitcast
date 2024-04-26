import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outfitcast/api/api_key.dart';
import 'package:outfitcast/data/data_outfit.dart';

class OutfitWidget extends StatefulWidget {
  final String city;

  const OutfitWidget({super.key, required this.city, required OutfitData outfitData});

  @override
  OutfitWidgetState createState() => OutfitWidgetState();
}

class OutfitWidgetState extends State<OutfitWidget> {
  List<Map<String, dynamic>> weatherData = [];

  final Map<String, String> _russianWeekdays = {
    'Mon': 'Пн',
    'Tue': 'Вт',
    'Wed': 'Ср',
    'Thu': 'Чт',
    'Fri': 'Пт',
    'Sat': 'Сб',
    'Sun': 'Вс',
  };

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  @override
  void didUpdateWidget(OutfitWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.city != oldWidget.city) {
      _fetchWeatherData();
    }
  }

  Future<void> _fetchWeatherData() async {
    try {
      var outfitData = OutfitData(apiKey: API_KEY);
      var data = await outfitData.loadOutfitData(widget.city);
      setState(() {
        weatherData = data;
      });
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.width * 0.35,
        margin: const EdgeInsets.symmetric(horizontal: 7),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFF1A1B1D),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weatherData.length,
            itemBuilder: (context, index) {
              var item = weatherData[index];
              var dateTime = DateTime.fromMillisecondsSinceEpoch(
                  (item['dt'] * 1000).toInt());
              var formattedTime =
                  '${_russianWeekdays[DateFormat.E().format(dateTime)]} | ${DateFormat.Hm().format(dateTime)}';
              var icon = item['weather'][0]['icon'];
              var temperature =
              (item['main']['feels_like'] as num).toInt();
              var images = _getImagesForTemperatureAndIcon(
                  temperature, icon);

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: const EdgeInsets.all(9.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF30343B),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formattedTime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var image in images)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF30343B),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 57,
                                  height: 57,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(image),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<String> _getImagesForTemperatureAndIcon(
      int temperature, String icon) {
    List<String> outfit = [];
    String key = _getTemperatureKey(temperature);

    if (temperatureImages.containsKey(key)) {
      outfit.addAll(temperatureImages[key]!);
    }

    _addAdditionalOutfitItems(outfit, temperature, icon);
    return outfit;
  }

  void _addAdditionalOutfitItems(
      List<String> outfit, int temperature, String icon) {
    if (temperature >= 0) {
      if (icon == '09d' ||
          icon == '09n' ||
          icon == '10d' ||
          icon == '10n' ||
          icon == '11d' ||
          icon == '11n') {
        outfit.add('assets/outfit/25/25_5.png');
        return;
      }
    }

    if (temperature >= 15) {
      if (icon == '01d' || icon == '02d' || icon == '04d') {
        outfit.add('assets/outfit/25/25_6.png');
        return;
      }
    }

    if (outfit.length < 5) {
      outfit.add('assets/outfit/25/capybara.png');
      return;
    }
  }

  String _getTemperatureKey(int temperature) {
    if (temperature <= -20) {
      return '-20';
    } else if (temperature <= -15) {
      return '-15';
    } else if (temperature <= -10) {
      return '-10';
    } else if (temperature <= -5) {
      return '-5';
    } else if (temperature <= 5) {
      return '5';
    } else if (temperature <= 10) {
      return '10';
    } else if (temperature <= 15) {
      return '15';
    } else if (temperature <= 20) {
      return '20';
    } else {
      return '25';
    }
  }

  static const Map<String, List<String>> temperatureImages = {
    '-20': [
      'assets/outfit/-20/-20_1.png',
      'assets/outfit/-20/-20_2.png',
      'assets/outfit/-20/-20_3.png',
      'assets/outfit/-20/-20_4.png',
      'assets/outfit/-20/-20_5.png',
    ],
    '-15': [
      'assets/outfit/-15/-15_1.png',
      'assets/outfit/-15/-15_2.png',
      'assets/outfit/-15/-15_3.png',
      'assets/outfit/-15/-15_4.png',
      'assets/outfit/-15/-15_5.png'
    ],
    '-10': [
      'assets/outfit/-10/-10_1.png',
      'assets/outfit/-10/-10_2.png',
      'assets/outfit/-10/-10_3.png',
      'assets/outfit/-10/-10_4.png',
      'assets/outfit/-10/-10_5.png'
    ],
    '-5': [
      'assets/outfit/-5/-5_1.png',
      'assets/outfit/-5/-5_2.png',
      'assets/outfit/-5/-5_3.png',
      'assets/outfit/-5/-5_4.png',
      'assets/outfit/-5/-5_5.png',
    ],
    '5': [
      'assets/outfit/5/5_1.png',
      'assets/outfit/5/5_2.png',
      'assets/outfit/5/5_3.png',
      'assets/outfit/5/5_4.png',
    ],
    '10': [
      'assets/outfit/10/10_1.png',
      'assets/outfit/10/10_2.png',
      'assets/outfit/10/10_3.png',
      'assets/outfit/10/10_4.png',
    ],
    '15': [
      'assets/outfit/15/15_1.png',
      'assets/outfit/15/15_2.png',
      'assets/outfit/15/15_3.png',
      'assets/outfit/15/15_4.png',
    ],
    '20': [
      'assets/outfit/20/20_1.png',
      'assets/outfit/20/20_2.png',
      'assets/outfit/20/20_3.png',
      'assets/outfit/20/20_4.png',
    ],
    '25': [
      'assets/outfit/25/25_1.png',
      'assets/outfit/25/25_2.png',
      'assets/outfit/25/25_3.png',
      'assets/outfit/25/25_4.png',
    ]
  };
}