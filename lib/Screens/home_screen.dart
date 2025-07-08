import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/movie_card.dart';
import './movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar películas al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      movieProvider.loadAllMovies();
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<AuthProvider>(context, listen: false).logout();
                },
                child: const Text('Cerrar sesión'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MovieSearchDelegate());
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem<String>(
                    value: 'user',
                    enabled: false,
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return Text(
                          authProvider.currentUser,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Cerrar sesión'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (movieProvider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${movieProvider.error}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      movieProvider.clearError();
                      movieProvider.loadAllMovies();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMovieSection(
                  title: 'Películas Populares',
                  movies: movieProvider.popularMovies,
                ),
                _buildMovieSection(
                  title: 'Mejor Calificadas',
                  movies: movieProvider.topRatedMovies,
                ),
                _buildMovieSection(
                  title: 'Próximas',
                  movies: movieProvider.upcomingMovies,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieSection({required String title, required List movies}) {
    if (movies.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(
                movie: movie,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// Delegado para la búsqueda de películas - VERSION CORREGIDA
class MovieSearchDelegate extends SearchDelegate {
  String _currentQuery = '';
  bool _hasSearched = false;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _currentQuery = '';
          _hasSearched = false;
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Ingresa un término de búsqueda'));
    }

    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        // Solo ejecutar búsqueda si la query ha cambiado
        if (_currentQuery != query) {
          _currentQuery = query;
          _hasSearched = false;

          // Ejecutar búsqueda solo una vez
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_hasSearched) {
              _hasSearched = true;
              movieProvider.searchMovies(query);
            }
          });
        }

        if (movieProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (movieProvider.searchResults.isEmpty && _hasSearched) {
          return const Center(child: Text('No se encontraron resultados'));
        }

        return ListView.builder(
          itemCount: movieProvider.searchResults.length,
          itemBuilder: (context, index) {
            final movie = movieProvider.searchResults[index];
            return MovieListCard(
              movie: movie,
              onTap: () {
                // Cerrar el search delegate y navegar a detalles
                close(context, null);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Busca películas por título'));
    }

    // Mostrar sugerencias basadas en la query actual
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        // Solo buscar si hay al menos 2 caracteres
        if (query.length >= 2 && _currentQuery != query) {
          _currentQuery = query;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            movieProvider.searchMovies(query);
          });
        }

        if (movieProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (movieProvider.searchResults.isEmpty) {
          return const Center(child: Text('Escribe para buscar películas'));
        }

        return ListView.builder(
          itemCount:
              movieProvider.searchResults.length > 5
                  ? 5
                  : movieProvider.searchResults.length,
          itemBuilder: (context, index) {
            final movie = movieProvider.searchResults[index];
            return ListTile(
              leading:
                  movie.posterPath != null
                      ? Image.network(
                        movie.fullPosterPath,
                        width: 40,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 40,
                            height: 60,
                            color: Colors.grey[300],
                            child: const Icon(Icons.movie, color: Colors.grey),
                          );
                        },
                      )
                      : Container(
                        width: 40,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.movie, color: Colors.grey),
                      ),
              title: Text(movie.title),
              subtitle: Text(movie.releaseDate),
              onTap: () {
                query = movie.title;
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}

// Widget para mostrar películas en lista (para la búsqueda) - VERSION MEJORADA
class MovieListCard extends StatelessWidget {
  final dynamic movie;
  final VoidCallback onTap;

  const MovieListCard({Key? key, required this.movie, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster
                Container(
                  width: 50,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child:
                        movie.posterPath != null
                            ? Image.network(
                              movie.fullPosterPath,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.movie,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                            : Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.movie,
                                color: Colors.grey,
                              ),
                            ),
                  ),
                ),
                const SizedBox(width: 12),
                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        movie.releaseDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
