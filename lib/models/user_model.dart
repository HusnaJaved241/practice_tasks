import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String? docId;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.docId,
  });
  get getFirstName => firstName;  
  get getLastName => lastName;  
  get getEmail => email;  
  UserModel.fromJson(dynamic json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        docId = json['docId'];

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'docId': docId
      };
}
