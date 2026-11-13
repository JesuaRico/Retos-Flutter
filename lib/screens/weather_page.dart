import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Future<Weather> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Weather>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          if (snap.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${snap.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => setState(() => _future = fetchWeather()),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          final w = snap.data!;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(w.city, style: Theme.of(context).textTheme.headlineMedium),
              Image.network(
                'https://openweathermap.org/img/wn/${w.icon}@4x.png',
                width: 140,
                height: 140,
              ),
              Text('${w.temp.round()}°C',
                  style: const TextStyle(
                      fontSize: 64, fontWeight: FontWeight.w300)),
              Text(
                w.description[0].toUpperCase() + w.description.substring(1),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              Text('Sensación: ${w.feelsLike.round()}°C   '
                  'Humedad: ${w.humidity}%   '
                  'Viento: ${w.wind} m/s'),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => setState(() => _future = fetchWeather()),
                icon: const Icon(Icons.refresh),
                label: const Text('Actualizar'),
              ),
            ],
          );
        },
      ),
    );
  }
}
