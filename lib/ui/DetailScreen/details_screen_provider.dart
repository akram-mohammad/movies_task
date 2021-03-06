import 'package:flutter/material.dart';
import 'package:iti_movies/repositories/movie_repo.dart';

class MovieProvider extends ChangeNotifier {
  dynamic movie;

  MovieRepository _movieRepository = MovieRepository();

  MovieProvider(id, index) {
    debugPrint('Movie ID :: $id');
    _getMovie(id, index);
  }

  void _getMovie(id, index) {
    _movieRepository.fetchMovie(id, index).then((newMovie) {
      movie = newMovie;
      debugPrint('provider fetching movie details');
      notifyListeners();
    });
  }
}
