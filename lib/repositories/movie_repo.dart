import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:iti_movies/local_storage/db_helper.dart';
import 'package:iti_movies/model/movies.dart';
import 'package:iti_movies/services/movie_services.dart';

class MovieRepository {
  MovieService _movieService = MovieService();
  Future<List<Movie>> fetchMovies() async {
    debugPrint('testing connectivity');
    var connectivityResult = await (Connectivity().checkConnectivity());
    final dbHelper = DbHelper.instance;
    if (connectivityResult == ConnectivityResult.none) {
      List<Map<String, dynamic>> dbMoviesMap = await dbHelper.queryAllRows();
      List<Movie> dbMovies =
          dbMoviesMap.map((e) => Movie.fromDatabase(e)).toList();
      return dbMovies;
    } else {
      final netMovies = await _movieService.fetchMovies();
      for (final movie in netMovies) {
        dbHelper.insert(movie.toMap());
      }
      return netMovies;
    }
  }

  Future<dynamic> fetchMovie(id, index) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    final dbHelper = DbHelper.instance;
    if (connectivityResult == ConnectivityResult.none) {
      List<Map<String, dynamic>> dbMoviesMap = await dbHelper.queryAllRows();
      Map<String, dynamic> dbMovieMap = dbMoviesMap[index];
      Movie dbMovie = Movie.fromDatabase(dbMovieMap);
      return dbMovie;
    } else {
      final netMovie = await _movieService.fetchMovie(id, index);
      Movie dbMovie = Movie.fromJson2(netMovie);
      return dbMovie;
    }
  }
}
