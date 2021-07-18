import 'package:flutter/material.dart';
import 'package:instagram/components/BottomNav.dart';

class Explore extends StatelessWidget {
  const Explore({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
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
                    for (int i = 0; i < 30; i++)
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Image.network(
                          "https://st.depositphotos.com/1428083/2946/i/600/depositphotos_29460297-stock-photo-bird-cage.jpg",
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 1,
      ),
    );
  }
}
