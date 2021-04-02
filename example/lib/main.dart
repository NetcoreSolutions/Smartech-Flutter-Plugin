import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

import 'profile_page.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  SmartechPlugin()
      .handleDeeplinkAction((String link, Map<dynamic, dynamic> map) {
    if (Platform.isAndroid) {
      if (link.isEmpty) {
        return;
      }
      if (link.contains('http')) {
        showDialog(
            context: Globle().context,
            builder: (builder) => AlertDialog(
                  title: Text(link),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(Globle().context).pop();
                          SmartechPlugin().openUrl(link);
                        },
                        child: Text("Ok"))
                  ],
                ));
      } else {
        Navigator.of(Globle().context)
            .push(MaterialPageRoute(builder: (builder) => ProfilePage()));
      }
    } else {
      showDialog(
          context: Globle().context,
          builder: (builder) => AlertDialog(
                title: Text(link),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(Globle().context).pop();
                      },
                      child: Text("Ok"))
                ],
              ));
    }
  });

  runApp(MyApp());
  getLocation();
}

void launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

getLocation() async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  //location.enableBackgroundMode(enable: true);

  _locationData = await location.getLocation();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  SmartechPlugin().handlePushNotification(message.data.toString());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      getToken();
      SmartechPlugin().setInAppCustomHTMLListener(customHTMLCallback);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  Future<void> customHTMLCallback(Map<String, dynamic> payload) async {
    print(payload);
  }

  getToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    print(token);
    if (token != null) {
      var _shp = await SharedPreferences.getInstance();
      var saveToken = _shp.get("token") ?? "";
      if (saveToken != token) {
        _shp.setString(token, "token");
        SmartechPlugin().setDevicePushToken(token);
      }
    }

    FirebaseMessaging.onMessage.listen((event) {
      if (event != null) {
        if (event.data != null) {
          SmartechPlugin().handlePushNotification(event.data.toString());
        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event != null) {
        if (event.data != null) {
          SmartechPlugin().handlePushNotification(event.data.toString());
        }
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if (event != null) {
        if (event.data != null) {
          SmartechPlugin().handlePushNotification(event.data.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class Globle {
  static final Globle _singleton = Globle._internal();

  factory Globle() {
    return _singleton;
  }

  Globle._internal();
  BuildContext context;
}
