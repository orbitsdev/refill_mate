import 'dart:convert';
import 'package:crypto/crypto.dart';

class User {
  int? id;
  String name;
  String email;
  String password; // store hashed
  String? profilePhotoPath;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.profilePhotoPath,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      profilePhotoPath: map['profile_photo_path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'profile_photo_path': profilePhotoPath,
    };
  }

  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
