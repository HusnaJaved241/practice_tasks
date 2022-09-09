import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';

class TextFieldProvider with ChangeNotifier {
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _password;
  bool isLoading = false;
  bool enableFields = false;

// Getters

  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get password => _password;

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setFields(bool value) {
    enableFields = value;
    notifyListeners();
  }

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
}
