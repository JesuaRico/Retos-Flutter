import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/movie.dart';

// Estado de ánimo -> id de género en TMDB (null = tendencias)
const moods = <String, int?>{
  '🔥 Tendencias': null,
  '😂 Feliz': 35, // Comedia
  '😢 Triste': 18, // Drama
  '💪 Con acción': 28, // Acción
  '❤️ Romántico': 10749, // Romance
  '😱 Con ganas de miedo': 27, // Terror
};

Future<List<Movie>> fetchMovies(int? genreId) async {
  final url = genreId == null
      ? 'https://api.themoviedb.org/3/trending/movie/week?api_key=$tmdbKey&language=es-MX'
      : 'https://api.themoviedb.org/3/discover/movie?api_key=$tmdbKey&language=es-MX'
          '&with_genres=$genreId&sort_by=popularity.desc&vote_count.gte=200';

  final res = await http.get(Uri.parse(url));
  if (res.statusCode != 200) {
    throw Exception('Error ${res.statusCode}. ¿Pusiste tu API key de TMDB?');
  }
  final data = jsonDecode(res.body);
  return (data['results'] as List).map((j) => Movie.fromJson(j)).toList();
}
