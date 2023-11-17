// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class UserEntity extends Equatable {
  String name;
  String email;
  String gender;
  String profilePic;
  String dateOfBirth;
  String createdAt;
  String phoneNumber;
  String uid;

  UserEntity({
    required this.name,
    required this.email,
    required this.gender,
    required this.profilePic,
    required this.dateOfBirth,
    required this.createdAt,
    required this.phoneNumber,
    required this.uid,
  });

  @override
  List<Object> get props {
    return [
      name,
      email,
      gender,
      profilePic,
      dateOfBirth,
      createdAt,
      phoneNumber,
      uid,
    ];
  }
}
