import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

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
      backgroundColor: Colors.blueAccent.shade700,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent.shade700, Colors.blueAccent.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),

                  // Título expandido
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Movie App',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return Text(
                              'Hola, ${authProvider.currentUser}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Botón de búsqueda
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.25),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: MovieSearchDelegate(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Menú de usuario
                  PopupMenuButton<String>(
                    icon: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white.withOpacity(0.25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        );
                      },
                    ),
                    onSelected: (value) {
                      if (value == 'logout') {
                        _logout();
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    itemBuilder:
                        (context) => [
                          PopupMenuItem<String>(
                            value: 'user',
                            enabled: false,
                            child: Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            Colors.blueAccent.shade100,
                                        child: Text(
                                          authProvider.currentUser.isNotEmpty
                                              ? authProvider.currentUser[0]
                                                  .toUpperCase()
                                              : 'U',
                                          style: TextStyle(
                                            color: Colors.blueAccent.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            authProvider.currentUser,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            'Usuario activo',
                                            style: TextStyle(
                                              color: Colors.blueGrey.shade700,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: Colors.red, size: 20),
                                SizedBox(width: 12),
                                Text('Cerrar sesión'),
                              ],
                            ),
                          ),
                        ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.blueAccent,
                    strokeWidth: 4,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Cargando películas...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                    ),
                  ),
                ],
              ),
            );
          }

          if (movieProvider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.redAccent,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${movieProvider.error}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      movieProvider.clearError();
                      movieProvider.loadAllMovies();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
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

    // Carrusel con indicadores solo para la primera sección
    if (title == 'Películas Populares') {
      return _MovieCarouselSection(movies: movies);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white70,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return _MovieCardModern(
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

// Carrusel superior con indicadores
class _MovieCarouselSection extends StatefulWidget {
  final List movies;
  const _MovieCarouselSection({Key? key, required this.movies})
    : super(key: key);

  @override
  State<_MovieCarouselSection> createState() => _MovieCarouselSectionState();
}

class _MovieCarouselSectionState extends State<_MovieCarouselSection> {
  int _currentPage = 0;
  final PageController _controller = PageController(viewportFraction: 0.85);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              const Text(
                'Películas Populares',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              // Chips de categorías
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [_CategoryChip(label: 'Popular', selected: true)],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.movies.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
              return _MovieCardModern(
                movie: movie,
                big: true,
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
        // Indicadores
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.movies.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
              width: _currentPage == i ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == i ? Colors.blueAccent : Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _CategoryChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: selected ? Colors.blueAccent : Colors.white10,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _MovieCardModern extends StatelessWidget {
  final dynamic movie;
  final VoidCallback onTap;
  final bool big;
  const _MovieCardModern({
    Key? key,
    required this.movie,
    required this.onTap,
    this.big = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = big ? MediaQuery.of(context).size.width * 0.7 : 130;
    final double height = big ? 180 : 180;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              movie.posterPath != null
                  ? Image.network(
                    movie.fullPosterPath,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.blueAccent.shade100,
                          child: const Icon(Icons.movie, color: Colors.white),
                        ),
                  )
                  : Container(
                    color: Colors.blueAccent.shade100,
                    child: const Icon(Icons.movie, color: Colors.white),
                  ),
              // Gradiente para mejor legibilidad
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.blueAccent.withOpacity(0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Título y año
              Positioned(
                left: 16,
                right: 16,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.2,
                        shadows: [
                          Shadow(
                            color: Colors.black87,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 4),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          movie.releaseDate,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 4),
                            ],
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
