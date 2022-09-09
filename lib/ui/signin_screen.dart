import 'package:flutter/material.dart';
import 'package:practice_firebase/controllers/auth_controller.dart';
import 'package:practice_firebase/validations/textfield_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formGlobalKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (Provider.of<TextFieldProvider>(context).isLoading)
              customLoadingWidget(),
            SingleChildScrollView(
              child: Container(
                height: currenHeight * 0.6,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customHeading('Sign In'),
                    Form(
                      key: formGlobalKey,
                      child: Column(
                        children: [
                          customTextFiled(
                            'Email',
                            emailController,
                            false,
                            emailValidator,
                            true,
                          ),
                          customTextFiled(
                            'Password',
                            passwordController,
                            true,
                            passwordValidator,
                            true,
                          ),
                          const SizedBox(height: 50),
                          customButton('Sign In', () async {
                            if (formGlobalKey.currentState!.validate()) {
                              formGlobalKey.currentState!.save();
                              Provider.of<TextFieldProvider>(context,
                                      listen: false)
                                  .setLoading(true);
                              var done = await context
                                  .read<AuthController>()
                                  .signinWithEmailAndPassword(
                                      emailController.text,
                                      passwordController.text,
                                      context);
                              Provider.of<TextFieldProvider>(context,
                                      listen: false)
                                  .setLoading(false);
                              if (done == "success") {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/main-screen', (route) => false);
                              } else if (done == "failed") {
                              } else {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/main-screen', (route) => false);
                              }
                            }
                          }),
                          GestureDetector(
                            onTap: () => Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/signup-screen',
                              (route) => false,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Sign up?',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
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
