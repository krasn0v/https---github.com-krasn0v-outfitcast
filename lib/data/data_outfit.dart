import 'dart:convert';
import 'package:http/http.dart' as http;

class OutfitData {
  static const String apiUrl = 'http://api.openweathermap.org/data/2.5/forecast';
  final String apiKey;

  OutfitData({required this.apiKey});

  Future<List<Map<String, dynamic>>> loadOutfitData(String city) async {
    var url = '$apiUrl?q=$city&appid=$apiKey&units=metric';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return (jsonData['list'] as List<dynamic>).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch outfit data');
    }
  }
}





