import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(MyApp(prefs));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
/*This should be used while in development mode, do NOT do this when you want to release to production, the aim of this answer is to make the development a bit easier for you, for production, you need to fix your certificate issue and use it properly, look at the other answers for this as it might be helpful for your case.*/

class MyApp extends StatefulWidget {
  final prefs;
  MyApp(this.prefs);

  @override
  _MyAppState createState() => _MyAppState(prefs);
}

class _MyAppState extends State<MyApp> {
  var prefs;
  var uid;

  @override
  _MyAppState(this.prefs);
  void initState() {
    uid = prefs.getString('uid');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram',
      initialRoute: (uid == null) ? '/' : '/feed',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
