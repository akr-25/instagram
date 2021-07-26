import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  static Future<Stream> get userPosts async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    return imageCollection.where('username', isEqualTo: username).snapshots();
  }
}












// class FirebaseFile {
//   final Reference ref;
//   final String name;
//   final String url;

//   const FirebaseFile({
//     required this.ref,
//     required this.name,
//     required this.url,
//   });
// }

// class ImageData {
  // static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
  //     Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  // static Future<List<FirebaseFile>> listAll(String path) async {
  //   final ref = FirebaseStorage.instance.ref(path);
  //   final result = await ref.listAll();

  //   final urls = await _getDownloadLinks(result.items);

  //   return urls
  //       .asMap()
  //       .map((index, url) {
  //         final ref = result.items[index];
  //         final name = ref.name;
  //         final file = FirebaseFile(ref: ref, name: name, url: url);

  //         return MapEntry(index, file);
  //       })
  //       .values
  //       .toList();
  // }


// }
