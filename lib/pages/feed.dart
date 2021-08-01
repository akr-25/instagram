import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/components/BottomNav.dart';
import 'package:instagram/components/FeedPost.dart';
import 'package:instagram/components/FeedStory.dart';
import 'package:instagram/services/images.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String? _username = "";
  String? _userDp;
  getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
      _userDp = prefs.getString('dpUrl');
    });
  }

  @override
  void initState() {
    getUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image(
          image: AssetImage("assets/camera.png"),
          height: 32.0,
          width: 32.0,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/message");
            },
            child: Image(
              image: AssetImage("assets/messenger.png"),
              height: 32.0,
              width: 32.0,
            ),
          ),
        ],
        title: Image(
          image: AssetImage("assets/instagram_logo.png"),
          height: 44,
          width: MediaQuery.of(context).size.width * 0.6,
        ),
        centerTitle: true,
        elevation: 1.2,
        // centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
          stream: ImageData.imageCollection
              .where('username', isNotEqualTo: _username) //Todo: fix this
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                      minWidth: MediaQuery.of(context).size.width,
                      maxHeight: 100.0,
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 0.3, color: Colors.grey))),
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (int i = 0; i < 10; i++)
                          Story(img: "assets/sample.jpg", text: "Your Story"),
                        // Story(img: "assets/sample.jpg", text: textS[i % 5]),
                      ],
                    ),
                  ),
                  ...snapshot.data!.docs.map((post) {
                    Map<String, dynamic> data =
                        post.data() as Map<String, dynamic>;
                    return Post(
                      docID: post.id,
                      caption: data["caption"],
                      image: data["photoUrl"],
                      username: data["username"],
                      isLiked: data["likedBy"].contains(_username),
                      numOfLike: data["likes"],
                      location: data["location"],
                      likedby: (data["likedBy"].length != 0)
                          ? data["likedBy"][data["likedBy"].length - 1]
                          : "none",
                      date: data["date"],
                      dp: data["dpUrl"] ??
                          "https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png",
                      userDp: _userDp ??
                          "https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png",
                    );
                  }),
                ],
              ),
            );
          }),
      bottomNavigationBar: const BottomNav(
        currentIndex: 0,
      ),
    );
  }
}
