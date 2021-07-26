import 'package:flutter/material.dart';
import 'package:instagram/components/BottomNav.dart';
import 'package:instagram/pages/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final numOfPics = 30;
  final crossAxisCount = 3;

  var _displayName = "loading", _bio, _website, _username = "loading";

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var __displayName =
    setState(() {
      _displayName = prefs.getString('displayName') ??
          prefs.getString('username') ??
          "error";
      _bio = prefs.getString('bio');
      _website = prefs.getString('website');
      _username = prefs.getString('username') ?? "error getting username";
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
      body: SingleChildScrollView(
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
                      backgroundImage: AssetImage("assets/Oval.png"),
                      radius: 36.0,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "54",
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
                      "834",
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
                      "54",
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: MediaQuery.of(context).size.width,
                child: Center(
                    heightFactor: 0.5,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => EditProfile()));
                      },
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 16),
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width *
                      (numOfPics / (crossAxisCount * crossAxisCount)) +
                  10,
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (int i = 0; i < numOfPics; i++)
                    FittedBox(
                      fit: BoxFit.fill,
                      child: Image.network(
                        "https://st.depositphotos.com/1428083/2946/i/600/depositphotos_29460297-stock-photo-bird-cage.jpg",
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 4,
      ),
    );
  }
}
