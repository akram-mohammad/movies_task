import 'package:flutter/cupertino.dart';
import 'package:iti_movies/model/movies.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';

class MovieService {
  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=6557d01ac95a807a036e5e9e325bb3f0&language=en-US'));
    if (response.statusCode == 200) {
      debugPrint("response headers: ${response.headers}");
      debugPrint("response body: ${response.body}");
      return List<Movie>.from((json.decode(response.body)["results"] as List)
          .map((e) => Movie.fromJson((e)))).toList();
    } else {
      throw Exception('FAILED TO LOAD Movies');
    }
  }

  Future<dynamic> fetchMovie(int id, int index) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$id?api_key=6557d01ac95a807a036e5e9e325bb3f0&language=en-US'));
    if (response.statusCode == 200) {
      debugPrint("response headers: ${response.headers}");
      debugPrint("response body: ${response.body}");
      return json.decode(response.body);
    } else {
      throw Exception('FAILED TO LOAD THE MOVIE');
    }
  }
}
