import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram/components/HorizontalOrLine.dart';
import 'package:instagram/pages/sign_up_page.dart';
import 'package:instagram/services/auth.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  ForgotPassState createState() => ForgotPassState();
}

class ForgotPassState extends State<ForgotPass> {
  final _emailController = TextEditingController();
  final AuthServices _auth = AuthServices();

  @override
  void dispose() {
    _emailController.dispose();
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
                                height: 50.0,
                                child: TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade600,
                                        width: 0.1,
                                      ),
                                    ),
                                    labelText: 'Email Address',
                                  ),
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
                                    await _auth.passwordReset(
                                        _emailController.text.trim());
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Send recovery email',
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
                              TextSpan(
                                text: "Don't have an account?",
                                children: [
                                  TextSpan(
                                      text: '  Sign up',
                                      style: TextStyle(color: Colors.blue),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SignUp(),
                                            ),
                                          );
                                        }),
                                ],
                              ),
                            ),
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
