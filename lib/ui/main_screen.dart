import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice_firebase/controllers/auth_controller.dart';
import 'package:practice_firebase/models/user_model.dart';
import 'package:provider/provider.dart';

import '../validations/textfield_provider.dart';
import '../widgets/custom_widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController? firstNameController = TextEditingController();
  TextEditingController? lastNameController = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  AuthController controller = AuthController();

  fetchData() {
    var myProvider = Provider.of<TextFieldProvider>(context, listen: false);
    controller.fetchUserData().then((value) {
      print(value);
      if (value != null) {
        myProvider.setfirstName(value.firstName);
        myProvider.setlastName(value.lastName);
        myProvider.setEmail(value.email);
      }
      firstNameController = TextEditingController(text: myProvider.firstName);
      lastNameController = TextEditingController(text: myProvider.lastName);
      emailController = TextEditingController(text: myProvider.email);
      passwordController = TextEditingController(text: myProvider.password);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentHeight = MediaQuery.of(context).size.height;
    var enableFields = Provider.of<TextFieldProvider>(context).enableFields;
    return SafeArea(
      child: Scaffold(
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
                              actionsPadding:
                                  const EdgeInsets.only(bottom: 15.0),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                customButton('Yes', () {
                                  controller.logoutUser();
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
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            height: currentHeight * 0.9,
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customHeading('Main Screen'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Stack(
                    children: [
                      if (firstNameController!.text.isEmpty ||
                          lastNameController!.text.isEmpty ||
                          emailController!.text.isEmpty)
                        Center(child: CircularProgressIndicator()),
                      Form(
                        key: formGlobalKey,
                        child: Column(
                          children: [
                            customTextFiled('First Name', firstNameController!,
                                false, nameValidator, enableFields),
                            customTextFiled('Last Name', lastNameController!,
                                false, nameValidator, enableFields),
                            customTextFiled('Email', emailController!, false,
                                emailValidator, enableFields),
                            const SizedBox(height: 50),
                            Provider.of<TextFieldProvider>(context).enableFields
                                ? customButton('Done', () async {
                                    if (formGlobalKey.currentState!
                                        .validate()) {
                                      formGlobalKey.currentState!.save();
                                      // update firestore data
                                      print(firstNameController!.text);
                                      controller.updateUserRecord({
                                        'firstName': firstNameController!.text,
                                        'lastName': lastNameController!.text,
                                        'email': emailController!.text,
                                      });
                                      Provider.of<TextFieldProvider>(context,
                                              listen: false)
                                          .setFields(false);
                                    }
                                  })
                                : customButton('Edit Profile', () async {
                                    Provider.of<TextFieldProvider>(context,
                                            listen: false)
                                        .setFields(true);
                                  }),
                            SizedBox(height: currentHeight * 0.05),
                            customButton('Detail Screen', () {
                              Navigator.pushNamed(context, '/detail-screen');
                            })
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
