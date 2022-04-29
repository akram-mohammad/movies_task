import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iti_movies/ui/ListScreen/list_screen.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _initFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final String messagingToken = await messaging.getToken() ?? '';
    debugPrint("You can push notification to the following token:");
    debugPrint("Device Notification Token : $messagingToken");

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'custom_notification_channel', // id
        'custom_notification_channel', // title
        description: 'custom_notification_channel', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id, channel.name,
              channelDescription: channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
              playSound: true,
              priority: Priority.high,
              importance: Importance.max,
            ),
          ),
        );
      }

      debugPrint(message.notification!.title.toString());
      debugPrint(message.notification!.body.toString());
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(message.notification!.title.toString());
      debugPrint(message.notification!.body.toString());
    });

    debugPrint('Firebase Messaging Init');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => ListScreen()),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    await Future.delayed(Duration(seconds: 1), _initFirebaseMessaging);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Image.asset(
          'assets/splash.png',
          width: 200,
        ),
      ),
    );
  }
}
