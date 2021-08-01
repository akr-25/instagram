import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/pages/dm.dart';
import 'package:instagram/pages/explore.dart';
import 'package:instagram/pages/facebook_login.dart';
import 'package:instagram/pages/feed.dart';
import 'package:instagram/pages/initial_page.dart';
import 'package:instagram/pages/login_page.dart';
import 'package:instagram/pages/messege.dart';
import 'package:instagram/pages/sign_up_page.dart';
import 'package:instagram/pages/user.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageRouteBuilder(
            pageBuilder: (_, animation1, animation2) => InitialPage(),
            transitionDuration: Duration(milliseconds: 0));
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUp());
      case '/facebook':
        return CupertinoPageRoute(builder: (_) => FacebookLogin());
      case '/dm':
        final args = settings.arguments as DmArguments;
        return MaterialPageRoute(
            builder: (_) => Dm(
                  username: args.username,
                  dpImage: args.dpImage,
                  toUid: args.toUid,
                ));
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
            pageBuilder: (_, animation1, animation2) => UserProfile(
                  isOwner: true,
                ),
            transitionDuration: Duration(milliseconds: 0));
      case '/visit':
        final args = settings.arguments as ScreenArguments;
        return MaterialPageRoute(
            builder: (_) => UserProfile(
                  isOwner: false,
                  username: args.username,
                  // bio: args.bio,
                  // website: args.website,
                  // dpUrl: args.dpUrl,
                  // displayName: args.displayName,
                ));
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

class ScreenArguments {
  // final dpUrl;
  // final displayName;
  final username;
  final isOwner;
  // final bio;
  // final website;
  // final followers;
  ScreenArguments({
    required this.isOwner,
    // this.dpUrl,
    // this.displayName,
    // this.bio,
    this.username,
    // this.website,
  });
}

class DmArguments {
  final username;
  final dpImage;
  final toUid;
  DmArguments(this.username, {this.dpImage, this.toUid});
}
