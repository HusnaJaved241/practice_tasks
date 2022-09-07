import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice_firebase/controllers/auth_controller.dart';
import 'package:practice_firebase/validations/textfield_validation.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController? firstNameController = TextEditingController();
  TextEditingController? lastNameController = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  bool? isLoading;
  @override
  void initState() {
    // TODO: implement initState

    final TextFieldProvider myProvider =
        Provider.of<TextFieldProvider>(context, listen: false);
    firstNameController = TextEditingController(text: myProvider.firstName);
    lastNameController = TextEditingController(text: myProvider.lastName);
    emailController = TextEditingController(text: myProvider.email);
    passwordController = TextEditingController(text: myProvider.password);
    // isLoading = myProvider.getloading();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    firstNameController!.dispose();
    lastNameController!.dispose();
    emailController!.dispose();
    passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currenHeight = MediaQuery.of(context).size.height;
    bool isloading = Provider.of<TextFieldProvider>(context).isLoading;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (isloading) 
              customLoadingWidget(),
            SingleChildScrollView(
              child: Container(
                height: currenHeight * 0.8,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customHeading('Sign Up'),
                    Form(
                      key: formGlobalKey,
                      child: Column(
                        children: [
                          customTextFiled(
                            'First Name',
                            firstNameController!,
                            false,
                            nameValidator,
                            true,
                          ),
                          customTextFiled(
                            'Last Name',
                            lastNameController!,
                            false,
                            nameValidator,
                            true,
                          ),
                          customTextFiled(
                            'Email',
                            emailController!,
                            false,
                            emailValidator,
                            true,
                          ),
                          customTextFiled(
                            'Password',
                            passwordController!,
                            true,
                            passwordValidator,
                            true,
                          ),
                          const SizedBox(height: 50),
                          customButton(
                            'Sign Up',
                            () async {
                              if (formGlobalKey.currentState!.validate()) {
                                formGlobalKey.currentState!.save();
                                // final userMap = {
                                //   'firstName': firstNameController.text,
                                //   'lastName': lastNameController.text,
                                //   'email': emailController.text,
                                // };
                                // var done = await context
                                //     .read<AuthController>()
                                //     .signupWithEmailAndPassword(
                                //         emailController.text,
                                //         passwordController.text,
                                //         userMap,
                                //         context);
                                Provider.of<TextFieldProvider>(context,
                                        listen: false)
                                    .setLoading(true);
                                await context
                                    .read<AuthController>()
                                    .otherSignupMethod(
                                        context,
                                        emailController!.text,
                                        passwordController!.text,
                                        firstNameController!.text,
                                        lastNameController!.text);
                                Provider.of<TextFieldProvider>(context,
                                        listen: false)
                                    .setLoading(false);
                                // if (done == "success") {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/signin-screen', (route) => false);
                                // } else if (done == "failed") {}
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
