import 'package:flutter/material.dart';
import 'package:outfitcast/api/api_key.dart';
import 'package:outfitcast/data/data_current.dart';
import 'package:outfitcast/data/data_daily.dart';
import 'package:outfitcast/data/data_hourly.dart';
import 'package:outfitcast/data/data_outfit.dart';
import 'package:outfitcast/widgets/widget_current.dart';
import 'package:outfitcast/widgets/widget_daily.dart';
import 'package:outfitcast/widgets/widget_hourly.dart';
import 'package:outfitcast/widgets/widget_input.dart';
import 'package:outfitcast/widgets/widget_outfit.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  ScreenState createState() => ScreenState();
}

class ScreenState extends State<Screen> {
  late String city;
  late CurrentData currentData;
  late HourlyData hourlyData;
  late DailyData dailyData;
  late OutfitData outfitData;
  bool showHourly = true;

  @override
  void initState() {
    super.initState();
    city = '';
    currentData = CurrentData(apiKey: API_KEY);
    hourlyData = HourlyData(apiKey: API_KEY);
    dailyData = DailyData(apiKey: API_KEY);
    outfitData = OutfitData(apiKey: API_KEY);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              InputWidget(
                city: city,
                onChanged: (value) {
                  setState(() {
                    city = value;
                  });
                  currentData.loadCurrentData(city);
                  hourlyData.loadHourlyData(city);
                  dailyData.loadDailyData(city);
                  outfitData.loadOutfitData(city);
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),
              if (currentData.getTemperature() != null &&
                  currentData.getHumidity() != null &&
                  currentData.getWindSpeed() != null &&
                  currentData.getWeatherIcon() != null)
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.75,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: CurrentWidget(city: city, currentWeather: currentData),
                )
              else
                const CircularProgressIndicator(),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                constraints: const BoxConstraints(
                  minWidth: double.infinity,
                  maxWidth: double.infinity,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF1A1B1D),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFF1A1B1D),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showHourly = true;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  color: showHourly
                                      ? const Color(0xFF59A1F5)
                                      : const Color(0xFF30343B),
                                ),
                                child: const Center(
                                  child: Text(
                                    'На Сегодня',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showHourly = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  color: !showHourly
                                      ? const Color(0xFF59A1F5)
                                      : const Color(0xFF30343B),
                                ),
                                child: const Center(
                                  child: Text(
                                    'На Неделю',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (showHourly)
                      HourlyWidget(hourlyData: hourlyData, city: city),
                    if (!showHourly)
                      DailyWidget(dailyData: dailyData, city: city),
                  ],
                ),
              ),
              OutfitWidget(outfitData: outfitData,city: city),
            ],
          ),
        ),
      ),
    );
  }
}