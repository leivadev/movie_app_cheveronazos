import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();

  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _searchResults = [];

  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Método para obtener películas populares
  Future<void> getPopularMovies() async {
    _setLoading(true);
    try {
      _popularMovies = await _movieService.getPopularMovies();
      _error = '';
      print('Películas populares obtenidas: ${_popularMovies.length}');
    } catch (e) {
      _error = 'Error al cargar películas populares: $e';
      print(_error);
    } finally {
      _setLoading(false);
    }
  }

  // Método para obtener películas mejor calificadas
  Future<void> getTopRatedMovies() async {
    _setLoading(true);
    try {
      _topRatedMovies = await _movieService.getTopRatedMovies();
      _error = '';
      print('Películas mejor calificadas obtenidas: ${_topRatedMovies.length}');
    } catch (e) {
      _error = 'Error al cargar películas mejor calificadas: $e';
      print(_error);
    } finally {
      _setLoading(false);
    }
  }

  // Método para obtener películas próximas
  Future<void> getUpcomingMovies() async {
    _setLoading(true);
    try {
      _upcomingMovies = await _movieService.getUpcomingMovies();
      _error = '';
      print('Películas próximas obtenidas: ${_upcomingMovies.length}');
    } catch (e) {
      _error = 'Error al cargar películas próximas: $e';
      print(_error);
    } finally {
      _setLoading(false);
    }
  }

  // Método para buscar películas
  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      _searchResults = await _movieService.searchMovies(query);
      _error = '';
      print('Resultados de búsqueda obtenidos: ${_searchResults.length}');
    } catch (e) {
      _error = 'Error al buscar películas: $e';
      print(_error);
    } finally {
      _setLoading(false);
    }
  }

  // Método para cargar todas las películas
  Future<void> loadAllMovies() async {
    await Future.wait([
      getPopularMovies(),
      getTopRatedMovies(),
      getUpcomingMovies(),
    ]);
  }

  // Método privado para manejar el estado de carga
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Método para limpiar errores
  void clearError() {
    _error = '';
    notifyListeners();
  }
}
