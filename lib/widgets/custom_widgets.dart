import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

Widget customListTile(text1, text2) {
  return ListTile(
    title: Text(
      text1,
      style: TextStyle(
        fontSize: 18.0,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: Text(
      text2,
      style: TextStyle(
        fontSize: 18.0,
        fontStyle: FontStyle.italic,
      ),
    ),
  );
}

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Widget customLoadingWidget() {
  return Container(
    color: Colors.white.withOpacity(0.4),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

String? nameValidator(String? name) {
  if (name!.isEmpty) return 'Name can\'t be empty';
}

String? emailValidator(String? email) {
  if (email!.isEmpty)
    return 'Email can\'t be empty';
  else if (!EmailValidator.validate(email.trim())) return 'Email is not valid';
  return null;
}

String? passwordValidator(String? password) {
  if (password!.isEmpty)
    return 'Password can\'t be empty';
  else if (password.length < 6)
    return 'Password length should not be less than 6';
  else
    return null;
}

Widget customTextFiled(String hint, TextEditingController controller,
    obscureText, customValidator, isEnabled) {
  return TextFormField(
    enabled: isEnabled,
    controller: controller,
    validator: customValidator,
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hint,
    ),
  );
}

Widget customHeading(heading) {
  return Text(
    heading,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 30.0,
      letterSpacing: 2.0,
    ),
  );
}

Widget customButton(buttonLabel, onButtonPressed) {
  return ElevatedButton(
    onPressed: onButtonPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 15.0,
      ),
    ),
    child: Text(buttonLabel),
  );
}
