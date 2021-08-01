import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/routes.dart';
import 'package:instagram/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final searchController = TextEditingController();
  bool _hasLoaded = false;
  String _username = "loading..";

  setData() async {
    log("message");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? "Error - Login Again";
    setState(() {
      _hasLoaded = true;
    });
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
            size: 32,
          ),
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _username,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: Colors.black,
            )
          ],
        ),
        actions: [
          Icon(
            Icons.add_outlined,
            color: Colors.black,
            size: 32,
          ),
          SizedBox(
            width: 10.0,
          )
        ],
      ),
      body: !_hasLoaded
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(color: Colors.white),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          // focusedBorder: InputBorder.none,
                          filled: true,
                          labelText: "Search",
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    StreamBuilder(
                      stream: DatabaseService.userCollection
                          // .where('searchKey',
                          //     isEqualTo: searchController.text.toLowerCase().substring(0, 1))
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            ...snapshot.data!.docs.map((post) {
                              Map<String, dynamic> data =
                                  post.data() as Map<String, dynamic>;
                              if (data["username"].toString().startsWith(
                                      searchController.text.toLowerCase()) ||
                                  searchController.text == "")
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  height: 80,
                                  alignment: Alignment.center,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/dm',
                                          arguments: DmArguments(
                                              data["username"],
                                              toUid: data["uid"],
                                              dpImage: NetworkImage(data[
                                                      'dpUrl'] ??
                                                  "https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png")));
                                    },
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(data[
                                              'dpUrl'] ??
                                          "https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png"),
                                    ),
                                    title: Text(data["displayName"] ??
                                        data["username"]),
                                    subtitle: (data["displayName"] != null)
                                        ? Text(data["username"])
                                        : null,
                                    // trailing: Icon(Icons.person_add_alt_1_rounded),
                                  ),
                                );
                              return SizedBox();
                            }),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
