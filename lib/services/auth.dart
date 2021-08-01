import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:instagram/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'memory.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService db = DatabaseService();
  final Memory mem = Memory();
  late String uid;

  Future passwordReset(email) async {
    try {
      var result = await _auth.sendPasswordResetEmail(email: email);
      return result;
    } catch (e) {
      throw (e.toString());
    }
  }

  changePassword(String password, String oldPassword) async {
    //Create an instance of the current user.
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString('email');
      if (email == null) throw ("email not found");
      User user = _auth.currentUser!;
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);

      await user.reauthenticateWithCredential(credential);

      //Pass in the password to updatePassword.
      user.updatePassword(password);
    } catch (e) {
      throw (e.toString());
    }
  }

  //Login using Facebook
  Future signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      log("success");
      try {
        // Create a credential from the access token
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        // Once signed in, return the UserCredential
        UserCredential user =
            await FirebaseAuth.instance.signInWithCredential(credential);
        mem.saveUser(user.user!.uid);
        bool userExists =
            await db.getUserDataUsingUid(user.user!.uid, returnType: bool);
        return userExists;
      } catch (e) {
        throw ("Unexpected error occurred");
      }
    } else if (result.status == LoginStatus.cancelled)
      throw ("Cancelled by user");
    throw ("Authentication failed");
  }

  //signing in through email and password
  Future signInWithEmailandPassword(
      {required String email, required String password}) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await mem.saveUser(user.user!.uid);
      await db.getCurrentUserData();
    } catch (e) {
      throw (e.toString());
    }
  }

  //creating a user and adding username into database
  Future<void> addUser({required email, required password, username}) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await DatabaseService().addUserData(
        userCredential: user,
        email: email,
        password: password,
        username: username,
      );
    } catch (e) {
      throw (e.toString());
    }
  }

  //getting the current user
  getCurrentUser() async {
    var _currentUser = _auth.currentUser;
    return _currentUser;
  }

  // signing out the user
  Future signOut() async {
    //Todo: implement signout through facebook
    try {
      await _auth.signOut();
      await mem.deleteUser();
    } catch (e) {
      throw (e.toString());
    }
  }
}
