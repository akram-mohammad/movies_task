import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iti_movies/blocs/deeplink_bloc.dart';
import 'package:iti_movies/ui/DetailScreen/details_screen.dart';
import 'package:iti_movies/ui/ListScreen/list_screen.dart';
import 'package:iti_movies/ui/SplashScreen/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.messageId}');
  debugPrint(message.notification!.title);
  debugPrint(message.notification!.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
        stream: _bloc.state,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: SplashScreen(),
            );
          } else {
            debugPrint("The Link Used : ${snapshot.data}");
            final List<String> _params =
                snapshot.data!.split('//')[1].split('/');
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
                body: SplashScreen(),
              );
            }
          }
        });
  }
}
