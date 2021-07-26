import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/pages/explore.dart';
import 'package:instagram/pages/feed.dart';
import 'package:instagram/pages/initial_page.dart';
import 'package:instagram/pages/login_page.dart';
import 'package:instagram/pages/messege.dart';
import 'package:instagram/pages/sign_up_page.dart';
import 'package:instagram/pages/user.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return PageRouteBuilder(
            pageBuilder: (_, animation1, animation2) => InitialPage(),
            transitionDuration: Duration(milliseconds: 0));
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUp());
      case '/feed':
        return PageRouteBuilder(
            pageBuilder: (_, animation1, animation2) => Feed(),
            transitionDuration: Duration(milliseconds: 0));
      case '/message':
        return CupertinoPageRoute(builder: (_) => Message());

      case '/explore':
        return PageRouteBuilder(
            pageBuilder: (_, animation1, animation2) => Explore(),
            transitionDuration: Duration(milliseconds: 0));
      case '/user':
        return PageRouteBuilder(
            pageBuilder: (_, animation1, animation2) => UserProfile(),
            transitionDuration: Duration(milliseconds: 0));
      default:
        {
          log('${settings.name}');
          return _errorRoute();
        }
    }
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Text('Error'),
      ),
    );
  });
}
