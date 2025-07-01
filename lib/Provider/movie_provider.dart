import 'package:flutter/material.dart';
import 'package:movie_app_cheveronazos/Models/movie.dart';
import 'package:movie_app_cheveronazos/Services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  List<Pelicula> _popularMovies = [];
  List<Pelicula> get popularMovies => _popularMovies;
  final MovieServices _movieServices = MovieServices();

  Future<void> fetchPopularMovies() async {
    _popularMovies = await _movieServices.fetchPopularMovies();
    notifyListeners();
  }

  Future<List<Pelicula>> searchMovies(String query) async {
    return await _movieServices.searchMovies(query);
  }
}
