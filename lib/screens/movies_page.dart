import 'dart:math';

import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/movie_card.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  String _mood = '🔥 Tendencias';
  late Future<List<Movie>> _future;
  bool _randomMode = false;
  int _randomSeed = 0;

  @override
  void initState() {
    super.initState();
    _future = fetchMovies(moods[_mood]);
  }

  void _selectMood(String mood) {
    setState(() {
      _mood = mood;
      _randomMode = false;
      _future = fetchMovies(moods[mood]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text('¿Cómo andas hoy?',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: moods.keys
                    .map((m) => ChoiceChip(
                          label: Text(m),
                          selected: _mood == m,
                          onSelected: (_) => _selectMood(m),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () => setState(() {
                  _randomMode = true;
                  _randomSeed = Random().nextInt(1000000);
                }),
                icon: const Icon(Icons.casino),
                label: const Text('Sorpréndeme con una'),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Movie>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('${snap.error}', textAlign: TextAlign.center),
                  ),
                );
              }
              final movies = snap.data!;
              if (movies.isEmpty) {
                return const Center(child: Text('No hay películas 😅'));
              }

              // Modo random: una sola película al azar
              if (_randomMode) {
                final m = movies[Random(_randomSeed).nextInt(movies.length)];
                return ListView(children: [MovieCard(movie: m)]);
              }

              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (_, i) => MovieCard(movie: movies[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}
