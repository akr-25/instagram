import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram/components/HorizontalOrLine.dart';
import 'package:instagram/pages/login_page.dart';
import 'package:instagram/services/auth.dart';
import 'package:instagram/services/database.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  String? _errorUserMessage;
  String? _errorConfirmPassMessage;
  String? _errorPassMessage;

  AuthServices _auth = AuthServices();
  DatabaseService _db = DatabaseService();
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
  void initState() {
    _isUserUnique();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
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
                          Image(
                            image: AssetImage('assets/instagram_logo.png'),
                            width: 250,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      (_errorUserMessage == null) ? 50.0 : 70.0,
                                  child: TextField(
                                    controller: _usernameController,
                                    onChanged: (value) async {
                                      await _isUserUnique();
                                    },
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
                                      errorText: _errorUserMessage,
                                    ),
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50.0,
                                  child: TextField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade600,
                                          width: 0.1,
                                        ),
                                      ),
                                      labelText: 'Email address',
                                    ),
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      (_errorPassMessage == null) ? 50.0 : 70.0,
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    onChanged: (value) {
                                      setState(() {
                                        if (_passwordController.text
                                                .trim()
                                                .length <
                                            6)
                                          _errorPassMessage =
                                              "Password is too short";
                                        else {
                                          _errorPassMessage = null;
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      errorText: _errorPassMessage,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade600,
                                          width: 0.1,
                                        ),
                                      ),
                                      labelText: 'Password',
                                    ),
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: (_errorConfirmPassMessage == null ||
                                          _errorPassMessage != null)
                                      ? 50.0
                                      : 70.0,
                                  child: TextField(
                                    controller: _confirmPassController,
                                    onChanged: (value) {
                                      setState(() {
                                        if (_passwordController.text.trim() !=
                                            _confirmPassController.text.trim())
                                          _errorConfirmPassMessage =
                                              "Password doesn't match!";
                                        else
                                          _errorConfirmPassMessage = null;
                                      });
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      errorText: (_errorPassMessage == null)
                                          ? _errorConfirmPassMessage
                                          : null,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade600,
                                          width: 0.1,
                                        ),
                                      ),
                                      labelText: 'Confirm Password',
                                    ),
                                  )),
                              SizedBox(
                                height: 20.0,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 50.0,
                                child: TextButton(
                                  onPressed: () async {
                                    if (_confirmPassController.text.trim() ==
                                            _passwordController.text.trim() &&
                                        (_errorUserMessage == null) &&
                                        (_usernameController.text != "")) {
                                      try {
                                        await _auth.addUser(
                                            email: _emailController.text.trim(),
                                            password:
                                                _passwordController.text.trim(),
                                            username: _usernameController.text
                                                .trim());
                                        Navigator.pushReplacementNamed(
                                            context, '/feed');
                                      } catch (e) {
                                        log(e.toString());
                                      }
                                    } else {
                                      log("Confirm password is not the same as password!!");
                                    }
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(color: Colors.white),
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

                    // Bottom Part

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          HorizontalOrLine(height: 10, label: "OR"),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                              child: Text.rich(
                                  TextSpan(text: 'Have an account?', children: [
                            TextSpan(
                                text: '  Log in',
                                style: TextStyle(color: Colors.blue),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ),
                                    );
                                  })
                          ]))),
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
