class Weather {
  final double temp;
  final String description;
  final String cityName;
  final String feeltemp;
  final String windSpeed;

  Weather({
    required this.windSpeed,
    required this.feeltemp,
    required this.temp,
    required this.description,
    required this.cityName,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      windSpeed: json['wind']['speed'].toString(),
      feeltemp: json['main']['feels_like'].toString(),
      temp: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      cityName: json['name'],
    );
  }
}
