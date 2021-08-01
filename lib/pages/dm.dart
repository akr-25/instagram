import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram/services/database.dart';
import 'package:instagram/services/memory.dart';
import 'package:instagram/services/message.dart';

class Dm extends StatefulWidget {
  const Dm(
      {Key? key,
      required this.username,
      required this.dpImage,
      required this.toUid})
      : super(key: key);
  final toUid;
  final dpImage;
  final username;
  @override
  _DmState createState() => _DmState();
}

class _DmState extends State<Dm> {
  final DatabaseService _db = DatabaseService();
  final MessageService _messageService = MessageService();
  late final _username, _dpImage;
  late final uid;
  late final _toUid;
  late final userMessageCollection;
  bool _hasLoaded = false;
  setData() async {
    uid = await Memory().getUid();
    var query = await MessageService.messageCollection
        .where('uid', isEqualTo: uid)
        .get();
    if (query.docs.isNotEmpty)
      userMessageCollection = query.docs.first.id;
    else {
      var docRef = await MessageService.messageCollection.add({
        'uid': uid,
      });
      userMessageCollection = docRef.id;
    }
    setState(() {
      _hasLoaded = true;
    });
  }

  @override
  void initState() {
    _username = widget.username;
    _dpImage = widget.dpImage;
    _toUid = widget.toUid;
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          _username,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: Colors.white),
              child: _hasLoaded
                  ? messages()
                  : Center(
                      child: Text("Lol, the developer is lazy af"),
                    ),
            ),
          ),
          sendMessage(),
        ],
      ),
    );
  }

  messages() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(userMessageCollection)
            .collection('messages')
            .where('toUid', isEqualTo: _toUid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitFadingCube(
                color: Colors.blue,
              ),
            );
          }
          return ListView(
            reverse: true,
            children: [
              ...snapshot.data!.docs.map((message) {
                Map<String, dynamic> data =
                    message.data() as Map<String, dynamic>;
                var content = data["message"];
                var myMessage = data["myMessage"];
                return Message(myMessage, content, _dpImage);
              })
            ],
          );
        });
  }

  sendMessage() {
    final _controller = TextEditingController();
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Type your message',
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0),
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: () async {
              if (_controller.text.trim() != "") {
                await _messageService.sendMessage(
                    toUid: _toUid,
                    collectionId: userMessageCollection,
                    text: _controller.text,
                    uid: uid);
                _controller.clear();
              }
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Message(myMessage, content, dpImage) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);
    return Row(
      mainAxisAlignment:
          myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!myMessage)
          CircleAvatar(
            radius: 16,
            backgroundImage: dpImage,
          ),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 140),
          decoration: BoxDecoration(
            color: myMessage ? Colors.grey[100] : Theme.of(context).accentColor,
            borderRadius: myMessage
                ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
          ),
          child: Column(
            crossAxisAlignment:
                myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                content,
                style:
                    TextStyle(color: myMessage ? Colors.black : Colors.white),
                textAlign: myMessage ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
