import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram/components/SnackBar.dart';
import 'package:instagram/services/auth.dart';
import 'package:instagram/services/database.dart';

// in this page we will take username and save it to the database if it doesn't
// exist, won't show this page if it exists!!

class FacebookLogin extends StatefulWidget {
  const FacebookLogin({Key? key}) : super(key: key);

  @override
  FacebookLoginState createState() => FacebookLoginState();
}

class FacebookLoginState extends State<FacebookLogin> {
  final _usernameController = TextEditingController();
  final AuthServices _auth = AuthServices();
  final DatabaseService _db = DatabaseService();
  String? _errorUserMessage;
  bool isSending = false;

  _isUserUnique() async {
    try {
      var _error = await _db.isUnique(_usernameController.text.trim());
      setState(() {
        _errorUserMessage = _error;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[50],
        // padding: EdgeInsets.all(20),
        child: Scaffold(
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Image(
                            image: AssetImage('assets/instagram_logo.png'),
                            width: 250,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    (_errorUserMessage == null) ? 50.0 : 70.0,
                                child: TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) async {
                                    await _isUserUnique();
                                  },
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade600,
                                          width: 0.1,
                                        ),
                                      ),
                                      labelText: 'Username',
                                      errorText: _errorUserMessage),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 50.0,
                                child: TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      isSending = true;
                                    });
                                    if (_errorUserMessage == null)
                                      try {
                                        await _db.addFacebookUser(
                                            _usernameController.text.trim());
                                        Navigator.pushReplacementNamed(
                                            context, '/feed');
                                      } catch (e) {
                                        var end = e.toString().indexOf(']');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(errorSnackBar(e
                                                .toString()
                                                .substring(end + 1)));
                                      }
                                    setState(() {
                                      isSending = false;
                                    });
                                  },
                                  child: !isSending
                                      ? Text(
                                          'Save username!',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : SpinKitThreeBounce(
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Divider(
                          height: 30,
                          thickness: 2,
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: Text('Instagram oT Facebook'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
