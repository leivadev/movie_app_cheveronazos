import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = '296d744040e08605373486e1d3ebb214'; // Reemplaza con tu API key

  Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=es-ES'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error al obtener películas populares: $e');
      return [];
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/top_rated?api_key=$_apiKey&language=es-ES'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error al obtener películas mejor calificadas: $e');
      return [];
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/upcoming?api_key=$_apiKey&language=es-ES'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error al obtener películas próximas: $e');
      return [];
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/search/movie?api_key=$_apiKey&language=es-ES&query=$query',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error al buscar películas: $e');
      return [];
    }
  }
}
