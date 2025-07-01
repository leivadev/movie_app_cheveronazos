import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_app_cheveronazos/Models/movie.dart';

class MovieServices {
  final String apiKey = 'f0b1c2d3e4f5g6h7i8j9k0l1m2n3o4p5';

  Future<List<Pelicula>> fetchPopularMovies() async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=1',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((movie) => Pelicula.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future findMovies(String query) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=en-US&query=$query&page=1&include_adult=false',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((movie) => Pelicula.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
}
