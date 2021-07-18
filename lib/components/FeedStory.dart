import 'package:flutter/material.dart';

class Story extends StatelessWidget {
  final String img, text;
  const Story({Key? key, required this.img, required this.text})
      : super(key: key);
  final double rad = 28.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  Colors.red,
                  Colors.purple,
                  Colors.red,
                  Colors.yellow,
                ], end: Alignment.bottomRight, begin: Alignment.topLeft)),
            child: CircleAvatar(
              child: CircleAvatar(
                backgroundImage: AssetImage(img),
                radius: rad - 2,
              ),
              backgroundColor: Colors.white,
              radius: rad,
            ),
          ),
          Text(
            text,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
