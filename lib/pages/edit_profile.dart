import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/components/SnackBar.dart';
import 'package:instagram/pages/change_password.dart';
import 'package:instagram/services/auth.dart';
import 'package:instagram/services/database.dart';
import 'package:instagram/services/images.dart';
import 'package:instagram/services/memory.dart';
import 'package:instagram/services/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final AuthServices _auth = AuthServices();
  final DatabaseService _db = DatabaseService();
  final ImageData _image = ImageData();
  final StorageRepo _repo = StorageRepo();
  final Memory mem = Memory();
  String? _errorUserMessage;

  _isUserUnique() async {
    var _username = await mem.getUserName();
    try {
      if (usernameController.text.trim() == _username) return null;
      var _error = await _db.isUnique(usernameController.text.trim());
      setState(() {
        _errorUserMessage = _error;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  final displayNameController = TextEditingController(text: "loading");
  final websiteController = TextEditingController(text: "");
  final bioController = TextEditingController(text: "");
  final usernameController = TextEditingController(text: "");
  late final String _uid;
  var _dpUrl;

  wid() {
    if (_dpUrl == null)
      return AssetImage('assets/Oval.png');
    else
      return NetworkImage(_dpUrl);
  }

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uid = prefs.getString('uid')!;
    setState(() {
      _dpUrl = prefs.getString('dpUrl');
      displayNameController.text = prefs.getString('displayName') ?? "";
      usernameController.text = prefs.getString('username') ?? "";
      bioController.text = prefs.getString('bio') ?? "";
      websiteController.text = prefs.getString('website') ?? "";
    });
  }

  @override
  void initState() {
    _isUserUnique();
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
              if (_errorUserMessage == null)
                try {
                  var uid = await Memory().getUid();
                  await _db.updateUserData(
                      uid: uid,
                      displayName: displayNameController.text.trim(),
                      username: usernameController.text.trim(),
                      website: websiteController.text.trim(),
                      bio: bioController.text.trim());
                  Navigator.pop(context);
                } catch (e) {
                  var end = e.toString().indexOf(']');
                  ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar(e.toString().substring(end + 1)));
                }
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
                backgroundImage: wid(),
                radius: 40,
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    XFile? image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (image == null) throw ("Image not selected");
                    File file = File(image.path);
                    var prefs = await SharedPreferences.getInstance();
                    var uid = prefs.getString('uid');
                    var username = prefs.getString('username');
                    String downloadUrl = await _repo.addUserDp(_uid, file);
                    await _db.updateUserData(uid: uid, dpUrl: downloadUrl);
                    _image.updateUserPost(
                        dpUrl: downloadUrl, username: username);
                    _dpUrl = prefs.getString('dpUrl');
                    setState(() {});
                  } catch (e) {
                    var end = e.toString().indexOf(']');
                    ScaffoldMessenger.of(context).showSnackBar(
                        errorSnackBar(e.toString().substring(end + 1)));
                  }
                },
                child: Text(
                  "Change Profile Picture",
                  style: TextStyle(color: Colors.blue.shade600),
                ),
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
                onChanged: (value) async {
                  await _isUserUnique();
                },
                decoration: InputDecoration(
                  labelText: "username",
                  errorText: _errorUserMessage,
                ),
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
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueAccent)),
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ChangePass()));
                  },
                  child: Text(
                    "Change Password",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.redAccent)),
                  onPressed: () async {
                    await _auth.signOut();
                    // await FacebookAuth.instance
                    //     .logOut()
                    //     .catchError((e) => log(e.toString()));
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: Text(
                    "Log out",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
