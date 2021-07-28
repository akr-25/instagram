import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/pages/feed.dart';

class Message extends StatelessWidget {
  const Message({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            // Navigator.pushNamed(context, "/feed");
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
              "jacob_w",
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
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Container(
                height: 60,
                padding: EdgeInsets.all(10),
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
                    // focusedBorder: InputBorder.none,
                    filled: true,
                    labelText: "Search",
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView(
                  children: [
                    for (int i = 0; i < 15; i++)
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 24,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 22,
                            child: CircleAvatar(
                              backgroundImage: AssetImage("assets/Oval.png"),
                            ),
                          ),
                        ),
                        title: Text("joshua_i"),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("ghumne chalega? goa trip"),
                            Text("now")
                          ],
                        ),
                        trailing: Icon(
                          Icons.camera_alt_outlined,
                          size: 32,
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
