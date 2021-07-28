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

  void changePassword(String password, String oldPassword) async {
    //Create an instance of the current user.
// ! Fix this and update memory!!
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString('email');
      if (email == null) throw ("email not found");
      User user = _auth.currentUser!;
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);

      user.reauthenticateWithCredential(credential);

      //Pass in the password to updatePassword.
      user.updatePassword(password);
    } catch (e) {
      throw (e.toString());
    }
  }

  //Stream to listen to auth state changes
  Stream<User?> get user {
    log(_auth.authStateChanges().toString());
    return _auth.authStateChanges();
  }

  //Login using Facebook
  Future<UserCredential?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      log("success");
      // Create a credential from the access token
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      db.getUserData();

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else if (result.status == LoginStatus.cancelled)
      throw ("cancelled by user");
    throw ("Authentication failed");
  }

  //signing in through email and password
  Future signInWithEmailandPassword(
      {required String email, required String password}) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await mem.saveUser(user.user!.uid);
      await db.getUserData();
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
  getUser() async {
    var _currentUser = _auth.currentUser;
    // final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
    // if (accessToken != null) {
    //   final userData = await FacebookAuth.instance.getUserData();
    //   return userData;
    // }
    return _currentUser;
  }

  // signing out the user
  Future signOut() async {
    //Todo: implement signout through facebook
    try {
      await _auth.signOut();
      await mem.deleteUser();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
