import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final likedby;
  var isLiked;
  final caption;
  final username;
  final location;
  final dp;
  final image;
  final numOfLike;
  final date;
  final userDp;

  Post(
      {Key? key,
      required this.isLiked,
      required this.caption,
      required this.username,
      required this.location,
      required this.dp,
      required this.image,
      required this.likedby,
      required this.numOfLike,
      required this.date,
      required this.userDp})
      : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Colors.black,
                      Colors.white
                      // Colors.red,
                      // Colors.purple,
                      // Colors.red,
                      // Colors.yellow,
                    ], end: Alignment.bottomRight, begin: Alignment.topLeft)),
                child: CircleAvatar(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.dp),
                    radius: 24,
                  ),
                  backgroundColor: Colors.white,
                  radius: 24,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.username}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    if (widget.location != null)
                      Text(
                        '${widget.location}',
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
        Image.network(widget.image),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        (widget.isLiked)
                            ? widget.isLiked = false
                            : widget.isLiked = true;
                      });
                      final snackBar = SnackBar(
                        backgroundColor: Colors.white,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                        content: Text(
                          "You Have Liked The Post",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blue),
                        ),
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Image(
                      image: AssetImage((widget.isLiked)
                          ? "assets/heart_pink_filled.png"
                          : "assets/heart_icon.png"),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Image(
                    image: AssetImage("assets/comment_icon.png"),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Image(
                    image: AssetImage("assets/messenger.png"),
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.userDp),
                    radius: 14,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                      'Liked by ${widget.likedby ?? "none"}  and ${widget.numOfLike} others')
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                      text: '${widget.username}',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                            text: '  ${widget.caption}',
                            style: TextStyle(fontWeight: FontWeight.normal)
                            // style: TextStyle(color: Colors.grey[800]),
                            )
                      ]),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '${widget.date}',
                  style: TextStyle(color: Colors.grey[400]),
                  textAlign: TextAlign.left,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
