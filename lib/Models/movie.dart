class Pelicula {
  final String title;
  final String posterPath;
  final String overview;
  final double voteAverage;

  Pelicula({
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
  });

  factory Pelicula.fromJson(Map<String, dynamic> json) {
    return Pelicula(
      title: json['title'],
      overview: json['overview'],
      posterPath: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }
}