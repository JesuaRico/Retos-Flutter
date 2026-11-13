import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/weather.dart';

// Intenta usar la ubicación del usuario; si falla devuelve null
Future<Position?> _getPosition() async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) return null;
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return null;
    }
    return await Geolocator.getCurrentPosition();
  } catch (_) {
    return null;
  }
}

Future<Weather> fetchWeather() async {
  double lat = 20.5236; // Celaya, Gto. (por defecto)
  double lon = -100.8157;

  final pos = await _getPosition();
  if (pos != null) {
    lat = pos.latitude;
    lon = pos.longitude;
  }

  final url = 'https://api.openweathermap.org/data/2.5/weather'
      '?lat=$lat&lon=$lon&appid=$weatherKey&units=metric&lang=es';
  final res = await http.get(Uri.parse(url));
  if (res.statusCode != 200) {
    throw Exception(
        'Error ${res.statusCode}. ¿Pusiste tu API key de OpenWeather? '
        '(puede tardar un rato en activarse)');
  }
  return Weather.fromJson(jsonDecode(res.body));
}
