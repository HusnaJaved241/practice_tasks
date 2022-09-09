import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practice_firebase/controllers/auth_controller.dart';
import 'package:practice_firebase/ui/signin_screen.dart';
import 'package:practice_firebase/ui/signup_screen.dart';
import 'package:practice_firebase/validations/textfield_provider.dart';
import 'package:provider/provider.dart';
import 'package:splash_view/splash_view.dart';
import 'package:splash_view/utils/done.dart';

import 'ui/detail_screen.dart';
import 'ui/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  User? result = FirebaseAuth.instance.currentUser;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthController>(
          create: (_) => AuthController(),
        ),
        ChangeNotifierProvider<TextFieldProvider>(
          create: (_) => TextFieldProvider(),
        ),
        StreamProvider(
          create: (context) => context.read<AuthController>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: SplashView(
            backgroundColor: Colors.white,
            duration: Duration(seconds: 3),
            logo: Image.asset(
              'assets/rolls-royce.png',
              width: 150.0,
            ),
            done: Done(AuthWrapper())),
        // home: SignupScreen(),
        routes: {
          '/signup-screen': (context) => SignupScreen(),
          '/signin-screen': (context) => SignInScreen(),
          '/main-screen': (context) => MainScreen(),
          '/detail-screen': (context) => DetailScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return MainScreen();
    }
    return SignInScreen();
  }
}
