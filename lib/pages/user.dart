import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/components/BottomNav.dart';
import 'package:instagram/components/SnackBar.dart';
import 'package:instagram/pages/edit_profile.dart';
import 'package:instagram/routes.dart';
import 'package:instagram/services/database.dart';
import 'package:instagram/services/images.dart';
import 'package:instagram/services/storage.dart';

class UserProfile extends StatefulWidget {
  final username;
  final isOwner;

  UserProfile({
    Key? key,
    required this.isOwner,
    this.username,
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var numOfPics = 30;
  final crossAxisCount = 3;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _displayName = "loading",
      _bio,
      _website,
      _username = "loading",
      _dpUrl,
      _uid,
      _ownerUsername,
      _isFollowing = false,
      _hasLoaded = false,
      _followers = 0,
      _following = 0;
  final DatabaseService _db = DatabaseService();

  setData() async {
    if (mounted) {
      var result;
      if (widget.isOwner)
        result = await _db.getCurrentUserData();
      else {
        result = await _db.getUserData(widget.username);
        await _db.getCurrentUserData().then((result) {
          if (result["data"]["following"].contains(widget.username))
            _isFollowing = true;
          else
            _isFollowing = false;
        });
      }
      var data = result["data"];
      setState(() {
        {
          _uid = data["uid"];
          _dpUrl = data["dpUrl"] ??
              "https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png";
          _displayName = data["displayName"] ?? data["username"] ?? "error";
          _bio = data["bio"];
          _website = data["website"];
          _username = data["username"] ?? "error getting username";
          _ownerUsername = data["username"];
          _followers = data["followers"].length;
          _following = data["following"].length;
          _hasLoaded = true;
        }
      });
    }
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
              size: 18,
              color: Colors.black,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              _username,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
            )
          ],
        ),
      ),
      body: _hasLoaded
          ? mainContent()
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: BottomNav(
        currentIndex: widget.isOwner ? 4 : 2,
      ),
    );
  }

  mainContent() {
    return StreamBuilder(
      stream: ImageData.imageCollection
          .where('username', isEqualTo: _username)
          // .orderBy('datetime')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        numOfPics = multipleOf3(snapshot.data!.docs.length) ?? 1; //?Logic here
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[500],
                    radius: 41,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(_dpUrl),
                        radius: 36.0,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "${snapshot.data!.docs.length}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Posts",
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "$_followers",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Followers",
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "$_following",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Following",
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$_displayName",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    if (_bio != null)
                      Text.rich(
                        TextSpan(
                          text: _bio,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          // children: [
                          //   TextSpan(
                          //       text: '  @pixsellz',
                          //       style: TextStyle(color: Colors.blue[800]))
                          // ],
                        ),
                      ),
                    SizedBox(
                      height: 1,
                    ),
                    if (_website != null)
                      Text(
                        _website,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue[800],
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.isOwner)
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => EditProfile()));
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          heightFactor: 0.5,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => EditProfile()));
                            },
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(fontSize: 16),
                            ),
                          )),
                    ),
                  ),
                ),
              if (!widget.isOwner)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _db.toggleFollowList(_username, _ownerUsername);
                        setState(() {
                          if (_isFollowing && !widget.isOwner) _followers--;
                          if (!_isFollowing && !widget.isOwner) _followers++;
                          if (_isFollowing && widget.isOwner) _following--;
                          if (!_isFollowing && widget.isOwner) _following--;
                          _isFollowing = !_isFollowing;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: Center(
                              heightFactor: 0.5,
                              child: TextButton(
                                onPressed: () async {
                                  await _db.toggleFollowList(
                                      _username, _ownerUsername);
                                  setState(() {
                                    if (_isFollowing && !widget.isOwner)
                                      _followers--;
                                    if (!_isFollowing && !widget.isOwner)
                                      _followers++;
                                    if (_isFollowing && widget.isOwner)
                                      _following--;
                                    if (!_isFollowing && widget.isOwner)
                                      _following--;
                                    _isFollowing = !_isFollowing;
                                  });
                                },
                                child: Text(
                                  _isFollowing ? "Unfollow" : "Follow",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/dm',
                            arguments: DmArguments(
                              _username,
                              dpImage: NetworkImage(_dpUrl),
                              toUid: _uid,
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: Center(
                              heightFactor: 0.5,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/dm',
                                      arguments: DmArguments(
                                        _username,
                                        dpImage: NetworkImage(_dpUrl),
                                        toUid: _uid,
                                      ));
                                },
                                child: Text(
                                  "Message",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width *
                    (numOfPics / (crossAxisCount * crossAxisCount)),
                // MediaQuery.of(context).size.height,
                child: GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      ...snapshot.data!.docs.map((post) {
                        Map<String, dynamic> data =
                            post.data() as Map<String, dynamic>;
                        return GestureDetector(
                          onLongPress: () {
                            if (widget.isOwner) {
                              bottomPopUp(post.id, data["photoUrl"]);
                            }
                          },
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(
                              data["photoUrl"],
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.blueGrey.shade50,
                                  child: Center(
                                    heightFactor: 2,
                                    widthFactor: 2,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      color: Colors.black87,
                                      strokeWidth: 2.0,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ]),
              )
            ],
          ),
        );
      },
    );
  }

  multipleOf3(num) {
    if (num % 3 == 0) {
      return num;
    }
    num++;
    return multipleOf3(num);
  }

  void bottomPopUp(docId, photoUrl) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text("Delete Post?",
                style: TextStyle(
                  color: Colors.red,
                )),
            onPressed: () async {
              await ImageData().deletePost(docId);
              await StorageRepo().deletePost(photoUrl);
              Navigator.pop(context);
              Future.delayed(Duration(seconds: 1), () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(postSnackBar("Post deleted successfully"));
              });
            },
          ),
        ],
      ),
    );
  }
}
