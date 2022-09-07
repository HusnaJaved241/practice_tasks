import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice_firebase/models/user_model.dart';

import '../widgets/custom_widgets.dart';

class AuthController {
  final auth = FirebaseAuth.instance;
  final collectionRef = FirebaseFirestore.instance.collection('users');

  Stream<User?> get authState => auth.authStateChanges();
  User get user => auth.currentUser!;
  logoutUser() {
    auth.signOut();
  }

  Future createUserRecord(userMap) async {
    User? user = await auth.currentUser;
    await collectionRef.doc(user!.uid).set(userMap);
  }

  Future<DocumentSnapshot> fetchCurrentUser(String uuid) async {
    DocumentSnapshot snap =
        // await FirebaseFirestore.instance.collection('users').doc(uuid).get();
        await collectionRef.doc(uuid).get();

    return snap;
  }

  Future updateUserRecord(userMap) async {
    User? user = await auth.currentUser;
    await collectionRef.doc(user!.uid).update(userMap);
  }

  Future signupWithEmailAndPassword(
      String email, String password, userMap, context) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await createUserRecord(userMap);
      return "success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          showSnackBar(context, "Email is invalid");
          break;
        case "email-already-in-use":
          showSnackBar(context, "Email is already in use");
          break;
      }
      return "failed";
    }
  }

  Future signinWithEmailAndPassword(
      String email, String password, context) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
        case "invalid-credential":
        case "user-not-found":
          showSnackBar(context, "Email is invalid");
          break;
        case "wrong-password":
          showSnackBar(context, "Password is incorrect");
          break;
      }
      return "failed";
    }
  }

  Future getUsersByEmail(context, String email) async {
    try {
      UserModel? userModel;
      var data = await collectionRef.where('email', isEqualTo: email).get();
      if (data.size > 0) {
        for (var document in data.docs) {
          userModel = UserModel.fromJson(document);
          print(userModel.firstName);
          print(userModel.lastName);
          return userModel;
        }
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.code);
    }
  }

  otherSignupMethod(context, String email, String password, String firstName,
      String lastName) async {
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {
              postDataToFirestore(
                context,
                firstName,
                lastName,
                email,
              )
            })
        .catchError((e) {
      showSnackBar(context, e!.message);
    });
  }

  postDataToFirestore(context, firstName, lastName, email) async {
    User? user = auth.currentUser!;

    await collectionRef.doc(user.uid).set(UserModel(
            firstName: firstName,
            lastName: lastName,
            email: email,
            docId: user.uid)
        .toJson());
    showSnackBar(context, 'Account Created Successfully...');
  }
}
