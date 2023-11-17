import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:simple_login_firebase/core/common/widgets/widgets.dart';
import 'package:simple_login_firebase/core/res/typhography_style.dart';

import 'package:simple_login_firebase/core/routes/routes.dart';
import 'package:simple_login_firebase/features/auth/presentation/cubit/auth_cubit.dart';

import '../../../../core/res/colours.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();

  bool isEmailExist = false;
  bool isPhoneSelected = true;
  bool isEmailSelected = false;
  String? phoneNumber;
  bool isLoading = false;

  List<Widget> icons = const [
    Icon(Icons.phone),
    Icon(Icons.email_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colours.white,
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              setState(() {
                isLoading = true;
              });

              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  isLoading = false;
                });
              });
            }

            if (state is SignInEmailSuccess) {
              setState(() {
                isLoading = false;
              });

              Get.toNamed(
                Routes.VERIFY_EMAIL,
                arguments: {'email': _emailController.text.trim()},
              );
            }

            if (state is SignInEmailVerifSuccess) {
              setState(() {
                isLoading = false;
              });
              Get.toNamed(
                Routes.PROFILE,
                arguments: {'userModel': state.userModel},
              );
            }

            if (state is SignInEmailError) {
              setState(() {
                isLoading = false;
              });

              context
                  .read<AuthCubit>()
                  .signInWithEmailVerification(_emailController.text.trim());
            }
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                top: 24,
                right: 24,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello',
                    style: TypographyStyle.bold48,
                  ),
                  Text(
                    'Again!',
                    style: TypographyStyle.bold48.copyWith(
                      color: Colours.bluePrimary,
                    ),
                  ),
                  Text(
                    'Welcome back you’vebeen missed',
                    style: TypographyStyle.regular20.copyWith(
                      color: Colours.grey,
                    ),
                  ),
                  const SizedBox(height: 80),
                  isPhoneSelected
                      ? IntlPhoneField(
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: UnderlineInputBorder(),
                          ),
                          initialCountryCode: 'ID',
                          showDropdownIcon: false,
                          onChanged: (phone) {
                            setState(() {
                              phoneNumber = phone.completeNumber.trim();
                            });
                          },
                        )
                      : CustomFormField(
                          label: 'email',
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                        ),
                  SizedBox(height: isPhoneSelected ? 30 : 58),
                  Center(
                      child: Text(
                    'Login With',
                    style: TypographyStyle.semi12,
                  )),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      signinOptions(
                          title: 'Phone',
                          isSelected: isPhoneSelected,
                          icon: Icons.phone,
                          onTap: () {
                            setState(() {
                              isPhoneSelected = true;
                              isEmailSelected = false;
                            });
                          }),
                      const SizedBox(
                        width: 50,
                      ),
                      signinOptions(
                          title: 'Email',
                          isSelected: isEmailSelected,
                          icon: Icons.email,
                          onTap: () {
                            setState(() {
                              isEmailSelected = true;
                              isPhoneSelected = false;
                            });
                          }),
                    ],
                  ),
                  const Spacer(),
                  ButtonPrimary(
                    isLoading: isLoading,
                    title: 'Login',
                    onPressed: () {
                      if (isPhoneSelected) {
                        context.read<AuthCubit>().signInWithPhone(phoneNumber!);
                      } else {
                        context
                            .read<AuthCubit>()
                            .signInWithEmail(_emailController.text.trim());
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget signinOptions({
    required VoidCallback onTap,
    required IconData icon,
    required bool isSelected,
    required String title,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colours.bluePrimary.withOpacity(0.5)
                  : Colours.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colours.grey.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? Colours.white
                  : Colours.bluePrimary.withOpacity(0.5),
            ),
          ),
          Text(title, style: TypographyStyle.semi12),
        ],
      ),
    );
  }
}
