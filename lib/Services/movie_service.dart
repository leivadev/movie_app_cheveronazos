import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app_cheveronazos/Models/movie.dart';

class MovieServices {
  final String? apiKey = dotenv.env['API_KEY'];

  Future<List<Pelicula>> fetchPopularMovies() async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?language=en-US&page=1',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((movie) => Pelicula.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Pelicula>> searchMovies(String query) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/search/movie?language=en-US&query=$query&page=1&include_adult=false',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((movie) => Pelicula.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
}
