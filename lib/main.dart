import 'package:flutter/material.dart';
import 'package:weather_app/Model/Weather.dart';
import 'package:weather_app/Services/weather_service.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
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
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureWeather = Future.error("Search a city");
  }

  String getWeatherAnimation(Weather weather) {
    double temp = weather.temp;
    String description = weather.description.toLowerCase();

    if (description.contains("thunderstorm")) {
      return 'https://lottie.host/4cf8564e-d1fe-4ca2-ad47-f08ac57da63a/VRN6MJVax2.json';
    } else if (description.contains("thunder")) {
      return 'https://lottie.host/ef35e6b1-80b9-40ba-8538-de3bbafa67ee/6bgrwpkZJE.json';
    } else if (description.contains("rain") || description.contains("shower")) {
      return 'https://lottie.host/3616f164-49e6-4738-8aff-f04b72e8eec3/nnL5DdqwY9.json';
    } else if (description.contains("cloud") ||
        description.contains("broken clouds")) {
      return 'https://lottie.host/a5e99722-3c49-4900-b73a-1051e20b5b69/D4KLxS73I3.json';
    } else if (description.contains("wind")) {
      return 'https://lottie.host/0fc8ac49-7d57-4c18-81b4-77c8e5cfab30/BNcaUp2Vpe.json';
    } else if (description.contains("clear sky")) {
      return 'https://lottie.host/145e29e8-5cf9-4e41-9f8d-19a167e0c1cc/HNdmbbRO9Y.json';
    } else {
      return 'https://lottie.host/a5e99722-3c49-4900-b73a-1051e20b5b69/D4KLxS73I3.json'; // Default cloudy
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: "City Name",
                    prefixIcon: const Icon(Icons.location_city_sharp),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 246, 246, 246),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter City Name';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                autofocus: true,
                onPressed: () {
                  if (_controller.text.isEmpty) {
                    setState(() {
                      _futureWeather = Future.error("Please enter a city name");
                    });
                    return;
                  }
                  setState(() {
                    _futureWeather = _weatherService.getWeather(
                      _controller.text.toLowerCase(),
                    );
                  });
                },
                child: Text("Search City"),
              ),
              SizedBox(height: 20),
              _controller.text.isEmpty
                  ? Text(
                    "Search a city",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                  : FutureBuilder<Weather>(
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
                              Stack(
                                children: [
                                  Lottie.network(
                                    getWeatherAnimation(weather!),
                                    height: 200,
                                    width: 200,
                                  ),

                                  Positioned(
                                    top: 140,
                                    right: -20,
                                    child: Container(
                                      width: 70,
                                      height: 30,
                                      child: Text(
                                        "${weather.temp}°C",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.redAccent,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10),
                              Text(
                                weather.cityName ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),

                              SizedBox(height: 10),
                              Text(
                                " Feel: ${weather.feeltemp}°C",
                                style: const TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              Text(
                                " Wind: ${weather.windSpeed}°C",
                                style: const TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Condition: ${weather.description}",
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
            ],
          ),
        ),
      ),
    );
  }
}
