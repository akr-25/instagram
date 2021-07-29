import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/components/BottomNav.dart';
import 'package:instagram/services/images.dart';
import 'package:instagram/services/memory.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  Memory mem = Memory();
  String? username;
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
      body: StreamBuilder(
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
                              child: Image.network(data["photoUrl"]),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      bottomNavigationBar: const BottomNav(
        currentIndex: 1,
      ),
    );
  }
}
