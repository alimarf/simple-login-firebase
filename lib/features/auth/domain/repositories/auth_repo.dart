import 'dart:io';

import 'package:simple_login_firebase/features/auth/data/models/user_model.dart';

import '../../../../core/utils/typedefs.dart';

abstract class AuthRepo {
  const AuthRepo();

  ResultFuture signInPhone({
    required String phoneNumber,
  });

  ResultFuture signInEmail({
    required String email,
  });

  ResultFuture signInWithEmailVerification({required String email});

  ResultFuture sendEmailVerification();

  ResultFuture<UserModel> verifyOtpCode({
    required String verificationId,
    required String otpCode,
  });

  ResultFuture<void> signUp({
    required UserModel userModel,
    required File profilePic,
  });

  Future<void> signOut();
}
