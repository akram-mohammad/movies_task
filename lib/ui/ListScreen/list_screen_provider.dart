import 'package:flutter/material.dart';
import 'package:iti_movies/model/movies.dart';
import 'package:iti_movies/repositories/movie_repo.dart';

class MoviesProvider extends ChangeNotifier {
  List<Movie> movies = [];
  MovieRepository _movieRepository = MovieRepository();

  MoviesProvider() {
    _getMovies();
  }

  void _getMovies() {
    _movieRepository.fetchMovies().then((newMovies) {
      movies = newMovies;
      notifyListeners();
    });
  }
}
