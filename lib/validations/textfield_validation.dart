import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';

class TextFieldProvider with ChangeNotifier {
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _password;
  bool isLoading = false;

// Getters

  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get password => _password;
  // bool isloading = false;

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // bool getloading() {
  //   return isloading;
  // }

  setfirstName(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  setlastName(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  // setters
  // void nameValidator(String? value) {
  //   if (value!.isEmpty)
  //     _name = TextFieldModel(value: value, error: "Name can't be empty");
  //   else
  //     _name = TextFieldModel(value: value, error: "");
  //   notifyListeners();
  // }

  // emailValidator(String? value) {
  //   if (value!.isEmpty)
  //     _email = TextFieldModel(value: value, error: "Email can\'t be empty.");
  //   else if (!EmailValidator.validate(value.trim()))
  //     _email = TextFieldModel(value: value, error: "Email is not valid.");

  //   notifyListeners();
  // }

  // passwordValidator(String? value) {
  //   if (value!.isEmpty)
  //     _password =
  //         TextFieldModel(value: value, error: "Password can't be empty.");
  //   else if (value.length < 6)
  //     _password = TextFieldModel(
  //         value: value, error: "Password length should nto be les than 6.");

  //   notifyListeners();
  // }
}
