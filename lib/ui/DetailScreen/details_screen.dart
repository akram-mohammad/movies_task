import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'details_screen_provider.dart';

class DetailScreen extends StatefulWidget {
  final id;
  final index;
  final movie;
  final saved;
  bool isDeepLinked;
  DetailScreen(
      {Key key,
      this.id,
      this.index,
      this.movie,
      this.saved,
      this.isDeepLinked = false})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<void> changePrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('saved', widget.saved);
    debugPrint('detail continue');
  }

  @override
  Widget build(BuildContext context) {
    final alreadySaved = widget.saved?.contains(widget.movie.title) ?? false;
    return ChangeNotifierProvider<MovieProvider>(
      create: (context) => MovieProvider(widget.id, widget.index),
      child: Consumer<MovieProvider>(builder: (buildContext, movieProvider, _) {
        if (movieProvider.movie != null) {
          final movie = movieProvider.movie;
          return Scaffold(
              appBar: AppBar(
                title: Text(movie.title),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        IconButton(
                            icon: Icon(
                              alreadySaved
                                  ? Icons.star_rate
                                  : Icons.star_border,
                              color: alreadySaved ? Colors.orangeAccent : null,
                            ),
                            onPressed: () {
                              setState(() {
                                if (alreadySaved) {
                                  widget.saved.remove(movie.title);
                                } else {
                                  widget.saved.add(movie.title);
                                }
                              });
                              changePrefs();
                            })
                      ],
                    ),
                  )
                ],
                leading: !widget.isDeepLinked
                    ? IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () =>
                            Navigator.of(context).pop(widget.saved),
                      )
                    : SizedBox(),
              ),
              body: (movieProvider.movie != null)
                  ? LayoutBuilder(
                      builder: (ctx, constraints) {
                        return Center(
                          child: ListView(
                            children: [
                              GestureDetector(
                                child: Hero(
                                  tag: 'imageHero${widget.index}',
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fitWidth,
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop(widget.saved);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    AutoSizeText(
                                      '${movie.title}',
                                      style: TextStyle(
                                          fontSize: constraints.maxWidth > 600
                                              ? 30
                                              : 25,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                                    Text(
                                      'Release Date: ${movie.releaseDate}',
                                      style: TextStyle(
                                          fontSize: constraints.maxWidth > 600
                                              ? 18
                                              : 14),
                                    ),
                                    SmoothStarRating(
                                        allowHalfRating: true,
                                        onRated: (v) {},
                                        starCount: 10,
                                        rating: movie.voteAverage,
                                        size: constraints.maxWidth > 600
                                            ? 25.0
                                            : 20.0,
                                        isReadOnly: true,
                                        filledIconData: Icons.star_rate,
                                        halfFilledIconData: Icons.star_half,
                                        color: Colors.orangeAccent,
                                        borderColor: Colors.black,
                                        spacing: 0.0),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Text(
                                        '${movie.overview}',
                                        style: TextStyle(
                                            fontSize: constraints.maxWidth > 600
                                                ? 18
                                                : 15),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  : Center(child: CircularProgressIndicator()));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.movie?.title ?? ''),
              leading: SizedBox(),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }),
    );
  }
}
