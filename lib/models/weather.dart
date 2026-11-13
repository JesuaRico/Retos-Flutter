class Weather {
  final String city;
  final double temp;
  final double feelsLike;
  final int humidity;
  final double wind;
  final String description;
  final String icon;

  Weather({
    required this.city,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.wind,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> j) => Weather(
        city: j['name'],
        temp: (j['main']['temp']).toDouble(),
        feelsLike: (j['main']['feels_like']).toDouble(),
        humidity: j['main']['humidity'],
        wind: (j['wind']['speed']).toDouble(),
        description: j['weather'][0]['description'],
        icon: j['weather'][0]['icon'],
      );
}
