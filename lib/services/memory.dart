import 'package:shared_preferences/shared_preferences.dart';

class Memory {
  List param = [
    "username",
    "displayName",
    "bio",
    "website",
    "email",
    "documentID",
    "dpUrl"
  ];

  setMemory(_userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    param.forEach((parameter) {
      if (_userData[parameter] != null)
        prefs.setString(parameter, _userData[parameter]);
    });
  }

  Future saveUser(uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid);
  }

  Future deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    param.forEach((parameter) {
      prefs.remove(parameter);
    });
  }

  getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}
