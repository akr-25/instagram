import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/components/BottomNav.dart';
import 'package:instagram/components/FeedPost.dart';
import 'package:instagram/components/FeedStory.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final textS = [
    "meri crush",
    "teri_crush",
    "uski_crush",
    "sabki_crush",
    "bas_hogaya"
  ];

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
      body: SingleChildScrollView(
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
                      bottom: BorderSide(width: 0.3, color: Colors.grey))),
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
            for (int i = 0; i < 10; i++)
              Post(
                caption:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                image:
                    "https://static.toiimg.com/thumb/msid-70872031,width-1200,height-900,resizemode-4/.jpg",
                username: "apna_clg",
                isLiked: false,
                numOfLike: 420,
                location: "Guwahati",
                likedby: "satan",
                date: "September 11",
                dp: "https://event.iitg.ac.in/icann2019/Proceedings_LaTeX/2019/IITG_White.png",
              )
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 0,
      ),
    );
  }
}
