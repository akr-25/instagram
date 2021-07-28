import 'package:flutter/material.dart';
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
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Image(
                    image: NetworkImage(_dpUrl),
                  ),
                  fit: BoxFit.fill,
                ),
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
                      labelText: 'Password',
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
                    _auth.changePassword(_passwordController.text.trim(),
                        _oldPasswordController.text.trim());
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ChangePass()));
                  },
                  child: Text(
                    "Change Password",
                    style: TextStyle(color: Colors.white),
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
