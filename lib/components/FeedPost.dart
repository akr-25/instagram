import 'package:flutter/material.dart';
import 'package:instagram/components/SnackBar.dart';
import 'package:instagram/services/images.dart';
import 'package:instagram/services/memory.dart';

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
  final docID;

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
      required this.userDp,
      required this.docID})
      : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  ImageData _imgDB = ImageData();

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
        Image.network(
          widget.image,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              color: Colors.blueGrey.shade50,
              child: Center(
                heightFactor: 1,
                widthFactor: 1,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.black87,
                  strokeWidth: 2.0,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        (widget.isLiked)
                            ? widget.isLiked = false
                            : widget.isLiked = true;
                      });
                      var _username = await Memory().getUserName();

                      if (widget.isLiked) {
                        _imgDB.updatePostLike(
                            username: _username,
                            liked: true,
                            docID: widget.docID);
                        ScaffoldMessenger.of(context).showSnackBar(
                            postSnackBar("You Have Liked The Post"));
                      } else {
                        _imgDB.updatePostLike(
                            username: _username,
                            liked: false,
                            docID: widget.docID);
                        ScaffoldMessenger.of(context).showSnackBar(
                            postSnackBar("You Have Unliked The Post"));
                      }
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
                  Text((widget.numOfLike == 0)
                      ? 'No one liked your picture, die!'
                      : (widget.numOfLike == 1)
                          ? 'Liked by ${widget.likedby}'
                          : 'Liked by ${widget.likedby}  and ${widget.numOfLike - 1} others')
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
