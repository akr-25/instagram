import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/services/database.dart';
import 'package:instagram/services/images.dart';
import 'package:instagram/services/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNav extends StatefulWidget {
  final currentIndex;
  const BottomNav({Key? key, @required this.currentIndex}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState(currentIndex);
}

class _BottomNavState extends State<BottomNav> {
  final currentIndex;
  _BottomNavState(this.currentIndex);

  int _selectedIndex = 0;

  final List<String> route = [
    "/feed",
    "/explore",
    "/feed",
    "/feed",
    "/user",
  ];

  void _onItemTapped(int index) {
    setDp();
    if (index == 0 || index == 1 || index == 4)
      Navigator.pushNamed(context, route[index]);
    if (index == 2)
      bottomPopUp();
    else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  String _dpUrl =
      "https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png";

  setDp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _dpUrl = prefs.getString('dpUrl') ??
        "https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  var once = true;

  @override
  Widget build(BuildContext context) {
    if (once == true) {
      _selectedIndex = currentIndex;
      once = false;
    }
    setDp();
    return BottomNavigationBar(
      selectedFontSize: 0.0,
      enableFeedback: true,
      unselectedFontSize: 0.0,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
            label: "",
            activeIcon: Image.asset("assets/home_icon.png"),
            icon: Image.asset("assets/home_inactive.png")),
        BottomNavigationBarItem(
            label: "",
            icon: Image.asset("assets/search_icon.png"),
            activeIcon: Image.asset("assets/search_active.png")),
        BottomNavigationBarItem(
          label: "",
          icon: Image.asset("assets/plus_icon.png"),
        ),
        BottomNavigationBarItem(
            label: "",
            icon: Image.asset("assets/heart_icon.png"),
            activeIcon: Image.asset("assets/heart_active.png")),
        BottomNavigationBarItem(
          label: "",
          icon: CircleAvatar(
            backgroundImage: NetworkImage(_dpUrl),
          ),
          activeIcon: CircleAvatar(
            backgroundColor: Colors.black,
            radius: 22,
            child: CircleAvatar(
              backgroundImage: NetworkImage(_dpUrl),
            ),
          ),
        ),
      ],
    );
  }

  void bottomPopUp() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text("Camera"),
            onPressed: () async {
              Navigator.pop(context);
              TextEditingController captionController = TextEditingController();
              showDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                        title: Text("Caption"),
                        content: CupertinoTextField(
                          controller: captionController,
                        ),
                        actions: [
                          CupertinoButton(
                              child: Text("Submit"),
                              onPressed: () {
                                cameraUpload(captionController.text);
                                Navigator.pop(context);
                              })
                        ],
                      ));
            },
          ),
          CupertinoActionSheetAction(
            child: Text("Gallery"),
            onPressed: () async {
              Navigator.pop(context);
              TextEditingController captionController = TextEditingController();
              showDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                        title: Text("Caption"),
                        content: CupertinoTextField(
                          controller: captionController,
                        ),
                        actions: [
                          CupertinoButton(
                              child: Text("Submit"),
                              onPressed: () {
                                galleryUpload(captionController.text);
                                Navigator.pop(context);
                              })
                        ],
                      ));
            },
          ),
        ],
      ),
    );
  }

  Future<void> galleryUpload(caption) async {
    final StorageRepo _repo = StorageRepo();
    final ImageData _imagedb = ImageData();
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) throw ("Image not selected");
      File file = File(image.path);
      var prefs = await SharedPreferences.getInstance();
      // var uid = prefs.getString('uid');
      var username = prefs.getString('username');
      String downloadUrl = await _repo.addPost(image.name, file);
      await _imagedb.addPostToDatabase(
          username: username, downloadUrl: downloadUrl, caption: caption);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> cameraUpload(caption) async {
    final StorageRepo _repo = StorageRepo();
    final ImageData _imagedb = ImageData();
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) throw ("Image not selected");
      File file = File(image.path);
      var prefs = await SharedPreferences.getInstance();
      // var uid = prefs.getString('uid');
      var username = prefs.getString('username');
      String downloadUrl = await _repo.addPost(image.name, file);
      await _imagedb.addPostToDatabase(
          username: username, downloadUrl: downloadUrl, caption: caption);
    } catch (e) {
      log(e.toString());
    }
  }
}
