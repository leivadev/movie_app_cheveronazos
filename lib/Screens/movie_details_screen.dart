import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  final dynamic movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade700,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade700,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card principal
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.shade400,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen y gradiente
                    GestureDetector(
                      onTap: () {
                        if (movie.posterPath != null &&
                            movie.posterPath != '') {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder:
                                (context) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  insetPadding: const EdgeInsets.all(16),
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap:
                                            () => Navigator.of(context).pop(),
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                movie.fullPosterPath,
                                                fit: BoxFit.contain,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Container(
                                                      color:
                                                          Colors
                                                              .blueAccent
                                                              .shade100,
                                                      child: const Icon(
                                                        Icons.movie,
                                                        color: Colors.white,
                                                        size: 120,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                          onPressed:
                                              () => Navigator.of(context).pop(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          );
                        }
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        child: SizedBox(
                          height: 220,
                          width: double.infinity,
                          child:
                              movie.posterPath != null && movie.posterPath != ''
                                  ? Image.network(
                                    movie.fullPosterPath,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.blueAccent.shade100,
                                              child: const Icon(
                                                Icons.movie,
                                                color: Colors.white,
                                                size: 60,
                                              ),
                                            ),
                                  )
                                  : Container(
                                    color: Colors.blueAccent.shade100,
                                    child: const Icon(
                                      Icons.movie,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                    // Gradiente inferior para legibilidad
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.blueAccent.shade700.withOpacity(0.85),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título y año
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  movie.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    letterSpacing: 0.2,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (movie.releaseDate != null &&
                                  movie.releaseDate.length >= 4)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '(${movie.releaseDate.substring(0, 4)})',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Duración, etc.
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                movie.releaseDate ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Sinopsis
                          const Text(
                            'Sinopsis',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.overview ?? 'Sin información.',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
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
