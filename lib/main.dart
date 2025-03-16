import 'package:flutter/material.dart';
import 'package:weather_app/Model/Weather.dart';
import 'package:weather_app/Services/weather_service.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Weather> _futureWeather;
  final WeatherService _weatherService = WeatherService(
    '4c06277090e5da8978544df39ee67d48',
  );

  @override
  void initState() {
    super.initState();
    _futureWeather = _weatherService.getWeather(25.1932, 67.1555);
  }

  // Function to determine animation URL based on weather conditions
  String getWeatherAnimation(Weather weather) {
    double temp = weather.temp;
    String description = weather.description.toLowerCase(); // Normalize text

    if (description.contains("thunderstorm")) {
      return 'https://lottie.host/4cf8564e-d1fe-4ca2-ad47-f08ac57da63a/VRN6MJVax2.json';
    } else if (description.contains("thunder")) {
      return 'https://lottie.host/ef35e6b1-80b9-40ba-8538-de3bbafa67ee/6bgrwpkZJE.json';
    } else if (description.contains("rain") || description.contains("shower")) {
      return 'https://lottie.host/3616f164-49e6-4738-8aff-f04b72e8eec3/nnL5DdqwY9.json';
    } else if (description.contains("cloud") ||
        description.contains("overcast")) {
      return 'https://lottie.host/a5e99722-3c49-4900-b73a-1051e20b5b69/D4KLxS73I3.json';
    } else if (description.contains("wind")) {
      return 'https://lottie.host/0fc8ac49-7d57-4c18-81b4-77c8e5cfab30/BNcaUp2Vpe.json';
    } else if (temp > 35) {
      return 'https://lottie.host/145e29e8-5cf9-4e41-9f8d-19a167e0c1cc/HNdmbbRO9Y.json';
    } else {
      return 'https://lottie.host/a5e99722-3c49-4900-b73a-1051e20b5b69/D4KLxS73I3.json'; // Default cloudy
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Weather>(
        future: _futureWeather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Weather? weather = snapshot.data;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weather?.cityName ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Lottie.network(
                    getWeatherAnimation(weather!),
                    height: 200,
                    width: 200,
                  ),

                  Text(
                    "${weather.temp}°C",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Condition: ${weather.description}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Min Temperature: ${weather.tempMin}°C",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Max Temperature: ${weather.tempMax}°C",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No Data Available"));
          }
        },
      ),
    );
  }
}
