import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/services/memory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  late String uid;
  final Memory mem = Memory();
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  //?check for unique username
  Future<String?>? isUnique(String? username) async {
    try {
      if (username == null) return null;
      QuerySnapshot<Object?> data =
          await userCollection.where('username', isEqualTo: username).get();
      if (data.docs.isNotEmpty)
        return "User already exist";
      else if (data.docs.isEmpty) return null;
    } catch (e) {
      throw (e);
    }
  }

  Future addUserData(
      {userCredential,
      username,
      required email,
      required password,
      bio,
      displayName,
      website}) async {
    final data = await userCollection.add({
      'password': password,
      // actual information
      'uid': userCredential.user.uid,
      'username': username,
      'email': email,
      'bio': bio,
      'displayName': displayName,
      'website': website,
      'dpUrl': null,
    });
    await mem.saveUser(userCredential.user!.uid);
    await mem.setMemory({
      'username': username,
      'displayName': displayName,
      'email': email,
      'bio': bio,
      'website': website,
      'documentID': data.id
    });
  }

  Future updateUserData(
      {required uid,
      userCredential,
      username,
      bio,
      displayName,
      website,
      dpUrl}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final documentID = prefs.getString("documentID");
      var _username = username ?? prefs.getString("username");
      var _bio = bio ?? prefs.getString("bio");
      var _displayName = displayName ?? prefs.getString("displayName");
      var _website = website ?? prefs.getString("website");
      var _dpUrl = dpUrl ?? prefs.getString("dpUrl");
      await userCollection.doc(documentID).update({
        'dpUrl': _dpUrl,
        'username': _username,
        'bio': _bio,
        'displayName': _displayName,
        'website': _website,
      });
      await mem.setMemory({
        'dpUrl': _dpUrl,
        'username': _username,
        'bio': _bio,
        'displayName': _displayName,
        'website': _website,
        'email': prefs.getString('email'),
        'documentID': documentID,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future getUserData() async {
    var uid = await mem.getUid();
    String? documentID;
    Object? data;
    QuerySnapshot<Object?> userData =
        await userCollection.where('uid', isEqualTo: uid).get();
    userData.docs.toList().forEach((element) {
      documentID = element.id;
      data = element.data();
    });
    await mem.setMemory(data);
    return {'documentID': documentID, 'data': data};
  }

  Stream<DocumentSnapshot<Object?>> get userData {
    return userCollection.doc(uid).snapshots();
  }
}
