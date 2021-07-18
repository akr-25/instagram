import 'package:flutter/material.dart';

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
    if (index == 0 || index == 1 || index == 4)
      Navigator.pushNamed(context, route[index]);
    else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  var once = true;

  @override
  Widget build(BuildContext context) {
    if (once == true) {
      _selectedIndex = currentIndex;
      once = false;
    }
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
          icon: Image(
            image: AssetImage("assets/Oval.png"),
            height: 38,
          ),
          activeIcon: CircleAvatar(
            backgroundColor: Colors.black,
            radius: 22,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/Oval.png"),
            ),
          ),
        ),
      ],
    );
  }
}
