import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_login_firebase/core/utils/typedefs.dart';
import 'package:simple_login_firebase/features/auth/data/models/user_model.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/auth_repo.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultFuture signInPhone({required String phoneNumber}) async {
    try {
      final result = await _remoteDataSource.signInWithPhone(
        phoneNumber: phoneNumber,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<UserModel> verifyOtpCode({
    required String verificationId,
    required String otpCode,
  }) async {
    try {
      final result = await _remoteDataSource.verifyOtpCode(
          verificationId: verificationId, otpCode: otpCode);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> signUp(
      {required UserModel userModel, required File profilePic}) async {
    try {
      final result = await _remoteDataSource.signUp(
          userModel: userModel, profilePic: profilePic);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<void> signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signOut();
    pref.clear();
  }

  @override
  ResultFuture sendEmailVerification() async {
    try {
      final result = await _remoteDataSource.sendEmailVerification();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture signInEmail({required String email}) async {
    try {
      final result = await _remoteDataSource.signInWithEmail(email: email);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture signInWithEmailVerification({required String email}) async {
    try {
      final result =
          await _remoteDataSource.signInEmailVerification(email: email);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
