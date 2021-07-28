import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class ImageData {
  static final CollectionReference imageCollection =
      FirebaseFirestore.instance.collection('images');

  Future<List<Map>> getUserPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      QuerySnapshot<Object?> imageData =
          await imageCollection.where('username', isEqualTo: username).get();
      List<String> param = ["photoUrl, datetime, caption, location, likes"];
      List<Map> posts = [];

      imageData.docs.toList().forEach((postData) {
        dynamic data = postData.data();
        Map post = {};
        param.forEach((element) {
          if (data[element] != null) post[element] = data[element];
        });
        posts.add(post);
      });
      return posts;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future addPostToDatabase(
      {required username, required String downloadUrl}) async {
    var monthInt = new DateTime.now().month;
    var month = formatDate(DateTime(monthInt), [M]);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      imageCollection.add({
        'photoUrl': downloadUrl,
        'likes': 0,
        'location': null,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
        'date': "${DateTime.now().day} $month",
        'caption': "default caption",
        'dpUrl': prefs.getString('dpUrl'),
      });
    } catch (e) {
      throw (e.toString());
    }
  }

  static Future<Stream> get userPosts async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    return imageCollection.where('username', isEqualTo: username).snapshots();
  }
}
