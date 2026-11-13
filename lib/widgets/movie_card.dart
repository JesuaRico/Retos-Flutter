import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          movie.posterPath != null
              ? Image.network(
                  'https://image.tmdb.org/t/p/w185${movie.posterPath}',
                  width: 110,
                  height: 165,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 110,
                  height: 165,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.movie, size: 40),
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('${movie.year}  ⭐ ${movie.rating.toStringAsFixed(1)}'),
                  const SizedBox(height: 6),
                  Text(
                    movie.overview.isEmpty
                        ? 'Sin descripción.'
                        : movie.overview,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
