import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iti_movies/ui/ListScreen/list_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../DetailScreen/details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<String> _saved = [];
  int _fav = 0;
  int listWideHeight = 100;
  int listNarrowHeight = 200;

  Future<void> fetchPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getStringList('saved') == null) {
      preferences.setStringList('saved', []);
    } else {
      _saved = preferences.getStringList('saved') ?? [];
      _fav = preferences.getStringList('saved')!.length;
      debugPrint(_fav.toString());
    }
  }

  Future<void> changePrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('saved', _saved);
    _fav = _saved.length;
  }

  @override
  Widget build(BuildContext context) {
    fetchPrefs();
    return ChangeNotifierProvider<MoviesProvider>(
      create: (context) => MoviesProvider(),
      child: Consumer<MoviesProvider>(
        builder: (buildContext, movieProvider, _) {
          debugPrint('building movies');
          return (movieProvider.movies != null)
              ? Scaffold(
                  appBar: AppBar(
                    title: Text('Movies'),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(_fav.toString()),
                            Icon(Icons.star_rate),
                          ],
                        ),
                      )
                    ],
                  ),
                  body: ListView.builder(
                    itemCount: movieProvider.movies.length,
                    itemBuilder: (ctx, index) {
                      final movie = movieProvider.movies[index];
                      final alreadySaved = _saved.contains(movie.title);
                      return LayoutBuilder(
                        builder: (ctx, constraints) {
                          return Container(
                            height: constraints.maxWidth > 600 ? 200 : 100,
                            child: GestureDetector(
                              child: Card(
                                child: Row(
                                  children: [
                                    Hero(
                                      tag: 'imageHero$index',
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: constraints.maxWidth >
                                                      600
                                                  ? const EdgeInsets.symmetric(
                                                      vertical: 10.0)
                                                  : const EdgeInsets.all(0),
                                              child: Text(
                                                movie.title.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        constraints.maxWidth >
                                                                600
                                                            ? 23
                                                            : 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                              ),
                                            ),
                                            Text(
                                              'Release Date: ${movie.releaseDate}',
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize:
                                                      constraints.maxWidth > 600
                                                          ? 15
                                                          : 13),
                                            ),
                                            SmoothStarRating(
                                                allowHalfRating: true,
                                                onRatingChanged: (v) {},
                                                starCount: 10,
                                                rating:
                                                    movie.voteAverage ?? 0.0,
                                                size: constraints.maxWidth > 600
                                                    ? 22
                                                    : 15,
                                                filledIconData: Icons.star_rate,
                                                halfFilledIconData:
                                                    Icons.star_half,
                                                color: Colors.orangeAccent,
                                                borderColor: Colors.black,
                                                spacing: 0.0),
                                            SizedBox(
                                              child: Text('${movie.overview}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  textAlign: TextAlign.start,
                                                  maxLines:
                                                      constraints.maxWidth > 600
                                                          ? 3
                                                          : 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        alreadySaved
                                            ? Icons.star_rate
                                            : Icons.star_border,
                                        color: alreadySaved
                                            ? Colors.orangeAccent
                                            : null,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (alreadySaved) {
                                            _saved.remove(movie.title);
                                          } else {
                                            _saved.add(movie.title!);
                                          }
                                        });
                                        changePrefs();
                                      },
                                    )
                                  ],
                                ),
                              ),
                              onTap: () async {
                                var result = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                            id: movie.id,
                                            index: index,
                                            movie: movie,
                                            saved: _saved)));
                                setState(() {
                                  _saved = result;
                                  _fav = _saved.length;
                                });
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    leading: null,
                  ),
                  backgroundColor: Colors.grey[100],
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
        },
      ),
    );
  }
}
