import 'dart:convert';

import 'package:simple_login_firebase/features/auth/domain/entities/user_entity.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: must_be_immutable
class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.email,
    required super.gender,
    required super.profilePic,
    required super.dateOfBirth,
    required super.createdAt,
    required super.phoneNumber,
    required super.uid,
  });

  UserModel.empty()
      : this(
          uid: '',
          email: '',
          name: '',
          dateOfBirth: '',
          createdAt: '',
          gender: '',
          phoneNumber: '',
          profilePic: '',
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'gender': gender,
      'profilePic': profilePic,
      'dateOfBirth': dateOfBirth,
      'createdAt': createdAt,
      'phoneNumber': phoneNumber,
      'uid': uid,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : super(
          name: map['name'] as String,
          email: map['email'] as String,
          gender: map['gender'] as String,
          profilePic: map['profilePic'] as String,
          dateOfBirth: map['dateOfBirth'] as String,
          createdAt: map['createdAt'] as String,
          phoneNumber: map['phoneNumber'] as String,
          uid: map['uid'] as String,
        );

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
