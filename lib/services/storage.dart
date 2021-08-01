import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepo {
  FirebaseStorage repo = FirebaseStorage.instance;

  Future<String> addUserDp(String uid, image) async {
    try {
      Reference ref = repo.ref('/user/$uid');
      var uploadTask = await ref.putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<String> addPost(String name, image) async {
    try {
      Reference ref = repo.ref('/image/$name');
      var uploadTask = await ref.putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw (e.toString());
    }
  }

  deletePost(photoUrl) async {
    Reference photoRef = repo.refFromURL(photoUrl);

    await photoRef.delete();
  }
}
