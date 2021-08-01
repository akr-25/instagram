import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/services/auth.dart';
import 'package:instagram/services/memory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  late String uid;
  final Memory mem = Memory();
  static final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  //?check for unique username
  Future<String?>? isUnique(String? username) async {
    try {
      if (username == null) return null;
      QuerySnapshot<Object?> data = await userCollection
          .where('username', isEqualTo: username.toLowerCase())
          .get();
      if (data.docs.isNotEmpty)
        return "User already exist";
      else if (data.docs.isEmpty) return null;
    } catch (e) {
      throw (e);
    }
  }

  Future addUserData(
      {userCredential,
      required String username,
      required String email,
      required password,
      bio,
      displayName,
      website}) async {
    final data = await userCollection.add({
      'password': password,
      // actual information
      'uid': userCredential.user.uid,
      'searchKey': username.substring(1, 2).toLowerCase(),
      'username': username.toLowerCase(),
      'email': email.toLowerCase(),
      'bio': bio,
      'displayName': displayName,
      'website': website,
      'dpUrl': null,
      'followers': [],
      'following': [],
    });
    await mem.saveUser(userCredential.user!.uid);
    await mem.setMemory({
      'username': username.toLowerCase(),
      'displayName': displayName,
      'email': email,
      'bio': bio,
      'website': website,
      'documentID': data.id
    });
  }

  Future addFacebookUser(String username) async {
    User currentUser = await AuthServices().getCurrentUser();
    final data = await userCollection.add({
      'uid': currentUser.uid,
      'searchKey': username.toLowerCase().substring(0, 1),
      'email': currentUser.email,
      'bio': null,
      'username': username,
      'displayName': null,
      'website': null,
      'dpUrl': null,
      'followers': [],
      'following': [],
    });
    await mem.saveUser(currentUser.uid);
    await mem.setMemory({
      'username': username.toLowerCase(),
      'email': currentUser.email,
      'documentID': data.id,
      'bio': null,
      'website': null,
      'displayName': null,
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
        'username': _username.toString().toLowerCase(),
        'searchKey': _username.toString().substring(1, 2).toLowerCase(),
        'bio': _bio,
        'displayName': _displayName,
        'website': _website,
      });
      await mem.setMemory({
        'dpUrl': _dpUrl,
        'username': _username.toString().toLowerCase(),
        'bio': _bio,
        'displayName': _displayName,
        'website': _website,
        'email': prefs.getString('email'),
        'documentID': documentID,
      });
    } catch (e) {
      throw (e.toString());
    }
  }

  Future getCurrentUserData() async {
    var uid = await mem.getUid();
    String? documentID;
    Map<String, dynamic>? data;
    QuerySnapshot<Object?> userData =
        await userCollection.where('uid', isEqualTo: uid).get();
    userData.docs.toList().forEach((element) {
      documentID = element.id;
      data = element.data() as Map<String, dynamic>;
    });
    var payload = data;
    payload!.addAll({'documentID': documentID});
    await mem.setMemory(payload);
    return {'documentID': documentID, 'data': data};
  }

  Stream<DocumentSnapshot<Object?>> get userData {
    return userCollection.doc(uid).snapshots();
  }

  Future getUserData(username) async {
    try {
      var data;
      var documentID;
      QuerySnapshot<Object?> userData =
          await userCollection.where('username', isEqualTo: username).get();
      userData.docs.toList().forEach((user) {
        data = user.data() as Map<String, dynamic>;
        documentID = user.id;
      });
      return {'data': data, 'documentID': documentID};
    } catch (e) {
      throw (e.toString());
    }
  }

  Future getUserDataUsingUid(uid, {returnType}) async {
    try {
      Map<String, dynamic> payload;
      DocumentSnapshot<Object?> userData = await userCollection.doc(uid).get();
      payload = userData.data() as Map<String, dynamic>;
      payload.addAll({'documentID': userData.id});
      await mem.setMemory(payload);
      if (returnType == bool) return true;
      return {'data': userData.data(), 'documentID': userData.id};
    } catch (e) {
      if (returnType == bool) return false;
      throw (e.toString());
    }
  }

  toggleFollowList(String username, ownerUsername) async {
    try {
      var ownerData = await getCurrentUserData();
      var data = await getUserData(username);
      var newFollowing = ownerData["data"]["following"] as List;
      var newFollowers = data!["data"]["followers"] as List;
      if (ownerData["data"]["following"].contains(username)) {
        newFollowing.remove(username);
        newFollowers.remove(ownerUsername);
      } else {
        newFollowing.add(username);
        newFollowers.add(ownerUsername);
      }

      userCollection.doc(ownerData["documentID"]).update({
        'following': newFollowing,
      });
      userCollection.doc(data["documentID"]).update({
        'followers': newFollowers,
      });
    } catch (e) {
      throw (e.toString());
    }
  }
}
