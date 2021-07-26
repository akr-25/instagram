import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:instagram/services/auth.dart';
import 'package:instagram/services/database.dart';
import 'package:instagram/services/memory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final AuthServices _auth = AuthServices();
  final DatabaseService db = DatabaseService();

  final displayNameController = TextEditingController(text: "loading");
  final websiteController = TextEditingController(text: "");
  final bioController = TextEditingController(text: "");
  final usernameController = TextEditingController(text: "");

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayNameController.text = prefs.getString('displayName') ?? "";
      usernameController.text = prefs.getString('username') ?? "";
      bioController.text = prefs.getString('bio') ?? "";
      websiteController.text = prefs.getString('website') ?? "";
    });
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  void dispose() {
    displayNameController.dispose();
    websiteController.dispose();
    bioController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          GestureDetector(
            onTap: () async {
              var uid = await Memory().getUid();
              await db.updateUserData(
                  uid: uid,
                  displayName: displayNameController.text.trim(),
                  username: usernameController.text.trim(),
                  website: websiteController.text.trim(),
                  bio: bioController.text.trim());
              Navigator.pushReplacementNamed(context, '/user');
            },
            child: Icon(
              Icons.check,
              // size: 40,
              color: Colors.black,
            ),
          )
        ],
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/Oval.png"),
                radius: 40,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Change Profile Picture",
                style: TextStyle(color: Colors.blue.shade600),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                maxLength: 20,
                controller: displayNameController,
              ),
              TextFormField(
                maxLength: 20,
                decoration: InputDecoration(labelText: "username"),
                controller: usernameController,
              ),
              TextFormField(
                maxLength: 20,
                decoration: InputDecoration(labelText: "website"),
                controller: websiteController,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Bio"),
                maxLength: 20,
                controller: bioController,
              ),
              TextButton(
                onPressed: () async {
                  await _auth.signOut();
                  // await FacebookAuth.instance
                  //     .logOut()
                  //     .catchError((e) => log(e.toString()));
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Text(
                  "Log out",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
