import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/components/BottomNav.dart';
import 'package:instagram/routes.dart';
import 'package:instagram/services/database.dart';
import 'package:instagram/services/images.dart';
import 'package:instagram/services/memory.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final Memory mem = Memory();
  String username = "";
  bool isTyping = false;
  final searchController = TextEditingController();
  initialise() async {
    username = await mem.getUserName();
    setState(() {});
  }

  @override
  void initState() {
    initialise();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leadingWidth: 0.0,
        centerTitle: false,
        title: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 40,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: searchController,
            onChanged: (value) {
              setState(() {
                isTyping = true;
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
              border: InputBorder.none,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              labelText: "Search",
              labelStyle: TextStyle(color: Colors.grey[700]),
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        actions: [Image.asset("assets/lens.png")],
      ),
      body: isTyping ? userList() : postGrid(),
      bottomNavigationBar: const BottomNav(
        currentIndex: 1,
      ),
      floatingActionButton: isTyping
          ? FloatingActionButton(
              // elevation: 0,
              backgroundColor: Colors.white,
              onPressed: () {
                searchController.text = "";
                isTyping = false;
                setState(() {});
              },
              child: Icon(
                Icons.cancel_outlined,
                size: 56,
                color: Colors.blueAccent.shade200,
              ))
          : null,
    );
  }

  userList() {
    return StreamBuilder(
      stream: DatabaseService.userCollection
          // .where('searchKey',
          //     isEqualTo: searchController.text.toLowerCase().substring(0, 1))
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            ...snapshot.data!.docs.map((post) {
              Map<String, dynamic> data = post.data() as Map<String, dynamic>;
              if (data["username"]
                      .toString()
                      .startsWith(searchController.text.toLowerCase()) ||
                  searchController.text == "")
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: 80,
                  alignment: Alignment.center,
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/visit',
                          arguments: ScreenArguments(
                            isOwner: false,
                            username: data["username"],
                            // displayName: data["displayName"],
                            // bio: data["bio"],
                            // website: data["website"],
                            // dpUrl: data["dpUrl"],
                          ));
                    }, //Todo implement kar le bhai
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    tileColor: Colors.blueGrey.shade100,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data['dpUrl'] ??
                          "https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png"),
                    ),
                    title: Text(data["displayName"] ?? data["username"]),
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
    );
  }

  postGrid() {
    return StreamBuilder(
        stream: ImageData.imageCollection
            .where('username', isNotEqualTo: username)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
                minHeight: MediaQuery.of(context).size.height,
                maxWidth: MediaQuery.of(context).size.width,
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: GridView.count(
                      // primary: false,
                      // padding: EdgeInsets.all(0),
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      crossAxisCount: 3,
                      // shrinkWrap: true,
                      children: [
                        ...snapshot.data!.docs.map((post) {
                          Map<String, dynamic> data =
                              post.data() as Map<String, dynamic>;
                          return FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(
                              data["photoUrl"] ??
                                  "https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png",
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
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
