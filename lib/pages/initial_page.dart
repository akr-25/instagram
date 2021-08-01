import 'dart:developer';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram/components/SnackBar.dart';
import 'package:instagram/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class InitialPage extends StatefulWidget {
  InitialPage({Key? key}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final AuthServices _auth = AuthServices();

  bool isSigning = false;

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
            height: 50,
            child: !isSigning
                ? SignInButton(
                    Buttons.Facebook,
                    text: "Sign in with Facebook",
                    onPressed: () async {
                      setState(() {
                        isSigning = true;
                      });
                      try {
                        bool result = await _auth.signInWithFacebook();
                        if (result == true)
                          Navigator.of(context).pushReplacementNamed('/feed');
                        else
                          Navigator.of(context).pushNamed('/facebook');
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(errorSnackBar(e.toString()));
                      }
                      setState(() {
                        isSigning = false;
                      });
                    },
                  )
                : SpinKitPumpingHeart(
                    color: Colors.pink,
                  ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
