import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_login_firebase/features/auth/data/models/user_model.dart';
import 'package:simple_login_firebase/features/auth/domain/usecases/sign_in_email.dart';
import 'package:simple_login_firebase/features/auth/domain/usecases/sign_in_phone.dart';
import 'package:simple_login_firebase/features/auth/domain/usecases/sign_in_with_email_verification.dart';
import 'package:simple_login_firebase/features/auth/domain/usecases/sign_out.dart';
import 'package:simple_login_firebase/features/auth/domain/usecases/sign_up.dart';
import 'package:simple_login_firebase/features/auth/domain/usecases/verify_otp.dart';

import '../../../../core/utils/constant_preferences.dart';
import '../../domain/usecases/send_email_verification.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInPhone _signInPhone;
  final VerifyOtp _verifyOtp;
  final SignUp _signUp;
  final SignOutUser _signOutUser;
  final SendEmailVerification _sendEmailVerification;
  final SignInEmail _signInEmail;
  final SignInWithEmailVerification _signInWithEmailVerification;

  AuthCubit({
    required SignInPhone signInPhone,
    required SignInEmail signInEmail,
    required VerifyOtp verifyOtp,
    required SignUp signUp,
    required SignOutUser signOutUser,
    required SendEmailVerification sendEmailVerification,
    required SignInWithEmailVerification signInWithEmailVerification,
  })  : _signInPhone = signInPhone,
        _signUp = signUp,
        _verifyOtp = verifyOtp,
        _signOutUser = signOutUser,
        _sendEmailVerification = sendEmailVerification,
        _signInEmail = signInEmail,
        _signInWithEmailVerification = signInWithEmailVerification,
        super(AuthInitial());

  void signInWithPhone(String phoneNumber) async {
    emit(AuthLoading());
    final result =
        await _signInPhone(SignInPhoneParams(phoneNumber: phoneNumber));

    result.fold(
      (failure) => emit(AuthError(errorMessage: failure.errorMessage)),
      (success) => emit(SiginPhoneSuccess()),
    );
  }

  void signInWithEmail(String email) async {
    emit(AuthLoading());
    final result = await _signInEmail(SignInEmailParams(email: email));

    result.fold(
      (failure) => emit(SignInEmailError(errorMessage: failure.errorMessage)),
      (success) => emit(SignInEmailSuccess()),
    );
  }

  void sendEmailVerification() async {
    emit(AuthLoading());
    final result = await _sendEmailVerification();

    result.fold(
      (failure) => emit(AuthError(errorMessage: failure.errorMessage)),
      (success) => emit(SendLinkEmailSuccess()),
    );
  }

  void verifyOtp({
    required String otpCode,
    required String verificationId,
  }) async {
    emit(VerifyOtpLoading());
    final result = await _verifyOtp(VerifyOtpParams(
      otpCode: otpCode,
      verificationId: verificationId,
    ));

    SharedPreferences pref = await SharedPreferences.getInstance();

    result.fold(
      (failure) => emit(VerifyOtpFailed(failure.errorMessage)),
      (data) {
        pref.setBool(Preferences.IS_SIGNED_IN, true);
        pref.setString(Preferences.USER, jsonEncode(data.toMap()));
        emit(VerifyOtpSuccess(userModel: data));
      },
    );
  }

  void signUp({required UserModel userModel, required File profilePic}) async {
    emit(RegisterLoading());
    final result = await _signUp(
        SignUpParams(userModel: userModel, profilePic: profilePic));
    SharedPreferences pref = await SharedPreferences.getInstance();

    result.fold((failure) => emit(RegisterFailed(failure.errorMessage)),
        (data) {
      pref.setBool(Preferences.IS_SIGNED_IN, true);
      pref.setString(Preferences.USER, jsonEncode(userModel.toMap()));
      emit(RegisterSuccess(userModel: userModel));
    });
  }

  void signOut() async {
    await _signOutUser();
    emit(SignOutSuccess());
  }

  Future<bool> checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool(Preferences.IS_SIGNED_IN) == true) {
      return true;
    } else {
      return false;
    }
  }

  void signInWithEmailVerification(String email) async {
    emit(AuthLoading());

    final result = await _signInWithEmailVerification(
        SignInEmailVerificationParams(email: email));
    SharedPreferences pref = await SharedPreferences.getInstance();

    result.fold((failure) => emit(RegisterFailed(failure.errorMessage)),
        (data) {
      pref.setBool(Preferences.IS_SIGNED_IN, true);
      pref.setString(Preferences.USER, jsonEncode(data.toMap()));
      emit(SignInEmailVerifSuccess(userModel: data));
    });
  }
}
