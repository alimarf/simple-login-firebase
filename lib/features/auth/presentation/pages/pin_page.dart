import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import 'package:simple_login_firebase/core/utils/toast_alert.dart';
import 'package:simple_login_firebase/features/auth/data/models/user_model.dart';
import 'package:simple_login_firebase/features/auth/presentation/cubit/auth_cubit.dart';

import '../../../../core/common/widgets/widgets.dart';
import '../../../../core/res/colours.dart';
import '../../../../core/res/typhography_style.dart';
import '../../../../core/routes/routes.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  String? otpCode;
  bool isLoading = false;

  String verificationId = Get.arguments['verificationId'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.white,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is VerifyOtpLoading) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is VerifyOtpSuccess) {
            setState(() {
              isLoading = false;
            });

            if (state.userModel == UserModel.empty()) {
              Get.offAndToNamed(Routes.REGISTER, arguments: {
                'email': '',
              });
            } else {
              Get.offAndToNamed(Routes.PROFILE, arguments: {
                'userModel': state.userModel,
              });
            }
          }
        },
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Text(
                    'Enter 6 digit PIN ',
                    style: TypographyStyle.semi16,
                  ),
                  const SizedBox(height: 24),
                  CustomPin(
                    onCompleted: (pin) {
                      setState(() {
                        otpCode = pin;
                      });
                    },
                  ),
                  const SizedBox(height: 40),
                  ButtonPrimary(
                    isLoading: isLoading,
                    title: 'Verify Otp',
                    onPressed: () {
                      if (otpCode != null) {
                        // verifyOtp(context, otpCode!);
                        context.read<AuthCubit>().verifyOtp(
                            otpCode: otpCode!, verificationId: verificationId);
                      } else {
                        ToastAlert.showToastWarningBottom(
                            title: 'Failed', message: 'Enter 6-Digits code');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
