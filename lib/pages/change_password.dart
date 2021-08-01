import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram/components/SnackBar.dart';
import 'package:instagram/services/auth.dart';
import 'package:instagram/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({Key? key}) : super(key: key);

  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final AuthServices _auth = AuthServices();
  final DatabaseService db = DatabaseService();
  bool isUpdating = false;
  String? _username;
  String _dpUrl =
      "https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png";

  var _errorPassMessage;
  var _errorConfirmPassMessage;

  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _oldPasswordController = TextEditingController();

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _dpUrl = prefs.getString('dpUrl') ??
        "https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png";
    _username = prefs.getString('username');
    setState(() {});
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(_dpUrl),
                radius: 80,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "$_username",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 28,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50.0,
                  child: TextField(
                    controller: _oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade600,
                          width: 0.1,
                        ),
                      ),
                      labelText: 'Old Password',
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: (_errorPassMessage == null) ? 50.0 : 70.0,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        if (_passwordController.text.trim().length < 6)
                          _errorPassMessage = "Password is too short";
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
                      labelText: 'New Password',
                    ),
                  )),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
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
                          _errorConfirmPassMessage = "Password doesn't match!";
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
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50.0,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueAccent)),
                  onPressed: () async {
                    if (_errorConfirmPassMessage == null &&
                        _errorPassMessage == null &&
                        _passwordController.text.trim() != "") {
                      setState(() {
                        isUpdating = true;
                      });
                      try {
                        await _auth.changePassword(
                            _passwordController.text.trim(),
                            _oldPasswordController.text.trim());
                        Navigator.pop(context);
                      } catch (e) {
                        var end = e.toString().indexOf(']');
                        ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(e.toString().substring(end + 1)));
                      }
                      setState(() {
                        isUpdating = false;
                      });
                    }
                  },
                  child: !isUpdating
                      ? Text(
                          "Change Password",
                          style: TextStyle(color: Colors.white),
                        )
                      : SpinKitThreeBounce(
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
