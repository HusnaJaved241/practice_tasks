import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice_firebase/controllers/auth_controller.dart';
import 'package:practice_firebase/models/user_model.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final formGlobalKey = GlobalKey<FormState>();
  bool enableFields = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserModel? loggedInUser = UserModel(firstName: "", lastName: "", email: "");
  AuthController controller = AuthController();

  @override
  void initState() {
    // TODO: implement initState

    controller.collectionRef
        .doc(controller.auth.currentUser!.uid)
        .get()
        .then((value) => setState(() {
              loggedInUser = UserModel.fromJson(value.data());
              print(loggedInUser!.email);
              firstNameController.text = loggedInUser!.firstName;
              lastNameController.text = loggedInUser!.lastName;
              emailController.text = loggedInUser!.email;
            }));

    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentHeight = MediaQuery.of(context).size.height;
    var authController = context.read<AuthController>();
    final currentUser = authController.user;
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 30.0, top: 15.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Text('Do you want to logout?'),
                            contentPadding: const EdgeInsets.all(25.0),
                            actionsPadding: const EdgeInsets.only(bottom: 15.0),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              customButton('Yes', () {
                                authController.logoutUser();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/signin-screen',
                                  (route) => false,
                                );
                              }),
                              customButton('No', () {
                                Navigator.pop(context);
                              }),
                            ],
                          ));
                },
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            height: currentHeight * 0.9,
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  customHeading('Main Screen'),
                  firstNameController.text.isEmpty ||
                          lastNameController.text.isEmpty ||
                          emailController.text.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Form(
                          key: formGlobalKey,
                          child: Column(
                            children: [
                              customTextFiled('First Name', firstNameController,
                                  false, nameValidator, enableFields),
                              customTextFiled('Last Name', lastNameController,
                                  false, nameValidator, enableFields),
                              customTextFiled('Email', emailController, false,
                                  emailValidator, enableFields),
                              const SizedBox(height: 50),
                              enableFields
                                  ? customButton('Done', () async {
                                      if (formGlobalKey.currentState!
                                          .validate()) {
                                        formGlobalKey.currentState!.save();
                                        // update firestore data
                                        authController.updateUserRecord({
                                          'firstName': firstNameController.text,
                                          'lastName': lastNameController.text,
                                          'email': emailController.text,
                                        });
                                        setState(() {
                                          enableFields = false;
                                        });
                                      }
                                    })
                                  : customButton('Edit Profile', () async {
                                      setState(() {
                                        enableFields = true;
                                      });
                                    }),
                              SizedBox(height: currentHeight * 0.05),
                              customButton('Detail Screen', () {
                                // authController
                                //     .getUsersByEmail(context,emailController.text);

                                Navigator.pushNamed(context, '/detail-screen');
                              })
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
          // child: FutureBuilder(
          //   future: controller.collectionRef
          //       .doc(controller.auth.currentUser!.uid)
          //       .get(),
          //   // future: authController.fetchCurrentUser(currentUser.uid),
          //   // future: authController.getUsersByEmail(
          //   //     context, authController.auth.currentUser!.email!),
          //   builder: (context, AsyncSnapshot<dynamic> snapshot) {
          //     if (snapshot.hasData) {
          //       // Map<String, dynamic> data =
          //       //     snapshot.data!.data() as Map<String, dynamic>;
          //       firstNameController.text = loggedInUser!.firstName;
          //       lastNameController.text = loggedInUser!.lastName;
          //       emailController.text = loggedInUser!.email;
          //       return Container(
          //         height: currentHeight * 0.9,
          //         padding: const EdgeInsets.all(20.0),
          //         child: SingleChildScrollView(
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               customHeading('Main Screen'),
          //               Form(
          //                 key: formGlobalKey,
          //                 child: Column(
          //                   children: [
          //                     customTextFiled(
          //                       'First Name',
          //                       firstNameController,
          //                       false,
          //                       nameValidator,
          //                       enableFields,
          //                     ),
          //                     customTextFiled(
          //                       'Last Name',
          //                       lastNameController,
          //                       false,
          //                       nameValidator,
          //                       enableFields,
          //                     ),
          //                     customTextFiled(
          //                       'Email',
          //                       emailController,
          //                       false,
          //                       emailValidator,
          //                       enableFields,
          //                     ),
          //                     const SizedBox(height: 50),
          //                     enableFields
          //                         ? customButton('Done', () async {
          //                             if (formGlobalKey.currentState!
          //                                 .validate()) {
          //                               formGlobalKey.currentState!.save();
          //                               // update firestore data
          //                               authController.updateUserRecord({
          //                                 'firstName': firstNameController.text,
          //                                 'lastName': lastNameController.text,
          //                                 'email': emailController.text,
          //                               });
          //                               setState(() {
          //                                 enableFields = false;
          //                               });
          //                             }
          //                           })
          //                         : customButton('Edit Profile', () async {
          //                             setState(() {
          //                               enableFields = true;
          //                             });
          //                           }),
          //                     SizedBox(height: currentHeight * 0.05),
          //                     customButton('Detail Screen', () {
          //                       // authController
          //                       //     .getUsersByEmail(context,emailController.text);

          //                       Navigator.pushNamed(context, '/detail-screen');
          //                     })
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     } else if (snapshot.hasError) {
          //       return Center(child: Text('An error occured'));
          //     } else {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //   },
          // ),
        ));
  }
}
