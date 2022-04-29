import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_movies/blocs/deeplink_bloc.dart';
import 'package:iti_movies/ui/DetailScreen/details_screen.dart';
import 'package:iti_movies/ui/ListScreen/list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => DeepLinkBloc(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Movies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
        stream: _bloc.state,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: ListScreen(),
            );
          } else {
            debugPrint("The Link Used : ${snapshot.data}");
            final List<String> _params =
                snapshot.data.split('//')[1].split('/');
            debugPrint("Params : ${_params.toString()}");
            if (_params[0] == "details_screen") {
              return Scaffold(
                body: DetailScreen(
                  id: int.parse(_params[1]),
                  isDeepLinked: true,
                ),
              );
            } else {
              return Scaffold(
                body: ListScreen(),
              );
            }
          }
        });
  }
}
