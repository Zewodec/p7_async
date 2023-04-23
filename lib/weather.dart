import 'dart:convert';

import 'package:http/http.dart' as http;

const apiKey = 'ac702d971fbd1803888da11f24e05370';

class Weather {
  static var _temp;

  static get getTemp => _temp;

  static Future<String> getWeather(String cityName) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _temp = data['main']['temp'];
      final weatherStatus = data['weather'][0]['main'];
      return '$_temp\u00B0C\n$weatherStatus';
    } else {
      throw Exception('Error: ${response.reasonPhrase}');
    }
  }
}
