import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_login_firebase/core/common/widgets/widgets.dart';
import 'package:simple_login_firebase/core/res/media_res.dart';
import 'package:simple_login_firebase/core/res/typhography_style.dart';
import 'package:simple_login_firebase/core/routes/routes.dart';

import 'package:simple_login_firebase/features/auth/presentation/cubit/auth_cubit.dart';

import '../../data/models/user_model.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  String email = Get.arguments['email'];
  UserModel userModel = UserModel.empty();
  bool isLoading = false;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              setState(() {
                isLoading = true;
              });
            }

            if (state is SendLinkEmailSuccess) {
              setState(() {
                isLoading = false;
              });
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(MediaRes.lottieEmail),
                Center(
                  child: Text(
                    'Check your Email',
                    textAlign: TextAlign.center,
                    style: TypographyStyle.semi14,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Center(
                    child: Text(
                      'We have sent you a Email on $email',
                      textAlign: TextAlign.center,
                      style: TypographyStyle.regular12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Center(
                    child: Text(
                      'Verifying email....',
                      textAlign: TextAlign.center,
                      style: TypographyStyle.regular14,
                    ),
                  ),
                ),
                const SizedBox(height: 57),
                SizedBox(
                  height: 50,
                  width: context.width * 0.3,
                  child: ButtonPrimary(
                    isLoading: isLoading,
                    title: 'Resend',
                    onPressed: () {
                      try {
                        context.read<AuthCubit>().sendEmailVerification();
                      } catch (e) {
                        debugPrint('$e');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkEmailVerified() async {
    await _firebaseAuth.currentUser?.reload();

    setState(() {
      isEmailVerified = _firebaseAuth.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email Successfully Verified")));

      timer?.cancel();

      var userData = await _getUserData(_firebaseAuth.currentUser!.uid);

      if (userData.docs.isNotEmpty) {
        Get.toNamed(Routes.PROFILE);
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

        Get.toNamed(Routes.PROFILE, arguments: {
          'userModel': userModel,
        });
      } else {
        Get.toNamed(Routes.REGISTER, arguments: {
          'email': email,
        });
      }
    }
  }

  Future<QuerySnapshot> _getUserData(String uid) async {
    return await _firebaseFirestore
        .collection('users')
        .where("uid", isEqualTo: _firebaseAuth.currentUser!.uid)
        .get();
  }
}
