import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  static final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('messages');

  sendMessage(
      {required toUid,
      required collectionId,
      required String text,
      required uid}) async {
    messageCollection.doc(collectionId).collection('messages').add({
      'message': text,
      'myMessage': true,
      'toUid': toUid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    var query = await MessageService.messageCollection
        .where('uid', isEqualTo: toUid)
        .get();
    if (query.docs.isNotEmpty)
      collectionId = query.docs.first.id;
    else {
      var docRef = await MessageService.messageCollection.add({
        'uid': toUid,
      });
      collectionId = docRef.id;
    }

    messageCollection.doc(collectionId).collection('messages').add({
      'message': text,
      'myMessage': false,
      'toUid': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
