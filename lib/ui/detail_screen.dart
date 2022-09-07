import 'package:flutter/material.dart';
import 'package:practice_firebase/widgets/custom_widgets.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentHeight = MediaQuery.of(context).size.height;
    var currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  // color: Color(0xFFE49E65),
                  color: Color(0xFFE0CBCB),
                ),
                height: currentHeight * 0.5,
                margin: EdgeInsets.symmetric(
                  horizontal: currentWidth * 0.1,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customListTile('Full Name', 'Husna Javed'),
                    customListTile('Email', 'husna@gmail.com'),
                    customListTile('Address', 'Mianwali'),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: currentHeight * 0.18,
                ),
                child: CircleAvatar(
                  radius: 50.0,
                  child: Text('DP'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
