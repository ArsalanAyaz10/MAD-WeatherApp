class Weather {
  final double temp;
  final double tempMin;
  final double tempMax;
  final String description;
  final String cityName;

  Weather({
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.cityName,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temp: json['main']['temp'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      description: json['weather'][0]['description'],
      cityName: json['name'],
    );
  }
}