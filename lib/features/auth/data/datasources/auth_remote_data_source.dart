import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/route_manager.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/toast_alert.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future signInWithEmail({
    required String email,
  });

  Future<UserModel> signInEmailVerification({
    required String email,
  });

  Future sendEmailVerification();

  Future signInWithPhone({required String phoneNumber});

  Future<UserModel> verifyOtpCode({
    required String verificationId,
    required String otpCode,
  });

  Future<void> signUp({
    required UserModel userModel,
    required File profilePic,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;

  const AuthRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
  })  : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  @override
  Future signInWithPhone({required String phoneNumber}) async {
    try {
      await _authClient.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _authClient.signInWithCredential(credential);

          Get.toNamed(Routes.PROFILE);
        },
        verificationFailed: (FirebaseAuthException error) {
          ToastAlert.showToastWarningBottom(
              title: 'Failed to Login', message: error.message!);
        },
        codeSent: (String verificationId, int? resendToken) async {
          Get.toNamed(
            Routes.PIN,
            arguments: {'verificationId': verificationId},
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UserModel> verifyOtpCode({
    required String verificationId,
    required String otpCode,
  }) async {
    UserModel userModel = UserModel.empty();
    PhoneAuthCredential creds = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpCode,
    );

    final result = await _authClient.signInWithCredential(creds);
    final user = result.user;

    var userData = await _getUserData(user!.uid);

    if (userData.docs.isNotEmpty) {
      userModel = UserModel(
        name: userData.docs.first['name'],
        email: userData.docs.first['email'],
        gender: userData.docs.first['gender'],
        profilePic: userData.docs.first['profilePic'],
        dateOfBirth: userData.docs.first['dateOfBirth'],
        createdAt: userData.docs.first['createdAt'],
        phoneNumber: userData.docs.first['phoneNumber'],
        uid: userData.docs.first['uid'],
      );

      return userModel;
    }
    return userModel;
  }

  Future<QuerySnapshot> _getUserData(String uid) async {
    return await _cloudStoreClient
        .collection('users')
        .where("uid", isEqualTo: _authClient.currentUser!.uid)
        .get();
  }

  @override
  Future<void> signUp({
    required UserModel userModel,
    required File profilePic,
  }) async {
    try {
      await storeFileToStorage("profilePic/${userModel.uid}", profilePic)
          .then((value) {
        userModel.profilePic = value;
        userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
        userModel.phoneNumber = _authClient.currentUser!.phoneNumber ?? '';
        userModel.uid = _authClient.currentUser!.uid;
      });

      await _cloudStoreClient.collection("users").doc().set(userModel.toMap());
    } on FirebaseAuthException catch (e) {
      ToastAlert.showToastWarningBottom(title: 'Failed', message: e.message!);
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _dbClient.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Future sendEmailVerification() async {
    try {
      User user = _authClient.currentUser!;

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future signInWithEmail({required String email}) async {
    try {
      await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: '123456',
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<UserModel> signInEmailVerification({required String email}) async {
    UserModel userModel = UserModel.empty();

    try {
      final result = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: '123456',
      );

      final user = result.user;

      if (user == null) {
        signInWithEmail(email: email);
      }

      var userData = await _getUserData(user!.uid);

      if (userData.docs.isNotEmpty) {
        userModel = UserModel(
          name: userData.docs.first['name'],
          email: userData.docs.first['email'],
          gender: userData.docs.first['gender'],
          profilePic: userData.docs.first['profilePic'],
          dateOfBirth: userData.docs.first['dateOfBirth'],
          createdAt: userData.docs.first['createdAt'],
          phoneNumber: userData.docs.first['phoneNumber'],
          uid: userData.docs.first['uid'],
        );

        return userModel;
      }
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }
}
