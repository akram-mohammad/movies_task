import 'dart:convert';

import 'package:iti_movies/local_storage/db_helper.dart';

Movie welcomeFromJson(String str) => Movie.fromJson(json.decode(str));

String welcomeToJson(Movie data) => json.encode(data.toJson());

class Movie {
  Movie({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.belongsToCollection,
    this.budget,
    this.genres,
    this.homepage,
    this.imdbId,
    this.revenue,
    this.runtime,
    this.status,
    this.tagline,
  });
  bool isfav = false;
  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;
  dynamic belongsToCollection;
  int? budget;
  List<Genre>? genres;
  String? homepage;
  String? imdbId;
  int? revenue;
  int? runtime;
  String? status;
  String? tagline;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  factory Movie.fromJson2(Map<String, dynamic> json) => Movie(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        belongsToCollection: json["belongs_to_collection"],
        budget: json["budget"],
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
        homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        revenue: json["revenue"],
        runtime: json["runtime"],
        status: json["status"],
        tagline: json["tagline"],
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds!.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  Map<String, dynamic> toMap() {
    return {
      DbHelper.COLUMN_ID: id,
      DbHelper.COLUMN_TITLE: title,
      DbHelper.COLUMN_BODY: overview,
      DbHelper.COLUMN_IMG: posterPath,
      DbHelper.COLUMN_RATE: voteAverage,
      DbHelper.COLUMN_RELEASE: releaseDate
    };
  }

  factory Movie.fromDatabase(Map<String, dynamic> json) => Movie(
      id: json[DbHelper.COLUMN_ID],
      overview: json[DbHelper.COLUMN_BODY],
      posterPath: json[DbHelper.COLUMN_IMG],
      title: json[DbHelper.COLUMN_TITLE],
      voteAverage: json[DbHelper.COLUMN_RATE],
      releaseDate: json[DbHelper.COLUMN_RELEASE]);
}

class Genre {
  Genre({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
