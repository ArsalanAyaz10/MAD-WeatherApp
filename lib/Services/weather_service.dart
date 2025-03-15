import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/Model/Weather.dart';

class WeatherService {
  final String apiKey;
  final String baseUrl = "api.openweathermap.org";

  WeatherService(this.apiKey);

Future<Weather> getWeather(double lat, double lon) async {
    final uri = Uri.https(
      baseUrl,
      '/data/2.5/weather',
      {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'appid': apiKey,
        'units': 'metric',
      },
    );

    final response  = await http.get(uri);

    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Failed to load weather data");
    }
  }
}
