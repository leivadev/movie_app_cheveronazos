import 'package:flutter/material.dart';
import 'package:movie_app_cheveronazos/Provider/movie_provider.dart';
import 'package:provider/provider.dart';
import 'package:movie_app_cheveronazos/Services/movie_service.dart';
import 'package:movie_app_cheveronazos/Widgets/movie_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Popular Movies')),
      body: FutureBuilder(
        future: movieProvider.fetchPopularMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: movieProvider.popularMovies.length,
              itemBuilder: (context, index) {
                final movie = movieProvider.popularMovies[index];
                return MovieItem(movie: movie);
              },
            );
          }
        },
      ),
    );
  }
}
