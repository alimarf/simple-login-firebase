import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:simple_login_firebase/core/res/typhography_style.dart';
import 'package:simple_login_firebase/core/utils/constant_preferences.dart';
import 'package:simple_login_firebase/features/auth/presentation/cubit/auth_cubit.dart';

import '../../../../core/res/colours.dart';
import '../../../../core/routes/routes.dart';
import '../../data/models/user_model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 2);

    return Timer(
      duration,
      () async {
        Future.delayed(const Duration(seconds: 1), () async {
          final isLogin = await context.read<AuthCubit>().checkLogin();

          SharedPreferences pref = await SharedPreferences.getInstance();
          String data = pref.getString(Preferences.USER) ?? '';

          if (data != '') {
            UserModel userModel = UserModel.fromMap(jsonDecode(data));
            if (isLogin) {
              Get.offAllNamed(Routes.PROFILE,
                  arguments: {'userModel': userModel});
            }
          } else {
            Get.offAllNamed(Routes.LOGIN);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.login_outlined),
            Text(
              'Simple',
              style: TypographyStyle.bold20
                  .copyWith(fontSize: 32, color: Colours.bluePrimary),
            ),
          ],
        ),
      ),
    );
  }
}
