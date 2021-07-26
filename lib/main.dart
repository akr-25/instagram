import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(MyApp(prefs));
}

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
