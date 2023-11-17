// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/typedefs.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repo.dart';

class SignUp extends UsecaseWithParams<void, SignUpParams> {
  const SignUp(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(SignUpParams params) => _repo.signUp(
        userModel: params.userModel,
        profilePic: params.profilePic,
      );
}

class SignUpParams extends Equatable {
  final UserModel userModel;
  final File profilePic;

  SignUpParams({
    required this.userModel,
    required this.profilePic,
  });

  @override
  List<Object> get props => [userModel, profilePic];
}
