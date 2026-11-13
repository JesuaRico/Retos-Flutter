class Movie {
  final String title;
  final String overview;
  final String? posterPath;
  final double rating;
  final String year;

  Movie({
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.rating,
    required this.year,
  });

  factory Movie.fromJson(Map<String, dynamic> j) {
    final date = (j['release_date'] ?? '') as String;
    return Movie(
      title: j['title'] ?? 'Sin título',
      overview: j['overview'] ?? '',
      posterPath: j['poster_path'],
      rating: (j['vote_average'] ?? 0).toDouble(),
      year: date.length >= 4 ? date.substring(0, 4) : '—',
    );
  }
}
