import 'dart:developer';
import 'package:instagram/services/auth.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatelessWidget {
  InitialPage({Key? key}) : super(key: key);

  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(),
          Image.asset('assets/instagram_logo.png'),
          Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
              child: Text(
                'Login with email',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
            ),
          ),
          SizedBox(
            height: 70.0,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: OutlinedButton(
                child: Text(
                  'Sign Up with email',
                  // style: TextStyle(color: Colors.blue),
                ),
                style: OutlinedButton.styleFrom(
                  primary: Colors.blue,
                  backgroundColor: Colors.grey[50],
                  side: BorderSide(color: Colors.blue, width: 1),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/signup');
                }),
          ),
          SizedBox(
            height: 70.0,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: OutlinedButton(
                child: Row(
                  children: [
                    Text(
                      'Login with Facebook',
                      // style: TextStyle(color: Colors.blue),
                    ),
                    Icon(Icons.facebook),
                  ],
                ),
                style: OutlinedButton.styleFrom(
                  primary: Colors.blue,
                  backgroundColor: Colors.grey[50],
                  side: BorderSide(color: Colors.blue, width: 1),
                ),
                onPressed: () async {
                  try {
                    await _auth.signInWithFacebook();
                    Navigator.of(context).pushNamed('/feed');
                  } catch (e) {
                    log(e.toString());
                  }
                }),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
