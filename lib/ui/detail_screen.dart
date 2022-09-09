import 'package:flutter/material.dart';
import 'package:practice_firebase/controllers/auth_controller.dart';
import 'package:practice_firebase/models/user_model.dart';
import 'package:practice_firebase/widgets/custom_widgets.dart';

class DetailScreen extends StatelessWidget {
  AuthController controller = AuthController();

  @override
  Widget build(BuildContext context) {
    var currentHeight = MediaQuery.of(context).size.height;
    var currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.grey,
            ),
            height: currentHeight * 0.5,
            margin: EdgeInsets.symmetric(
              horizontal: currentWidth * 0.1,
            ),
            child: FutureBuilder(
                future: controller.fetchUserData(),
                builder: (context, AsyncSnapshot<UserModel?> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customListTile(
                            'Full Name',
                            snapshot.data!.firstName +
                                " " +
                                snapshot.data!.lastName),
                        customListTile('Email Address', snapshot.data!.email),
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ),
      ),
    );
  }
}
