import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import 'package:simple_login_firebase/core/routes/routes.dart';
import 'package:simple_login_firebase/features/auth/data/models/user_model.dart';
import 'package:simple_login_firebase/features/auth/presentation/cubit/auth_cubit.dart';

import '../../../../core/common/widgets/widgets.dart';
import '../../../../core/res/colours.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  UserModel userModel = Get.arguments['userModel'];

  @override
  void initState() {
    super.initState();
    _nameController.text = userModel.name;
    _dateController.text = userModel.dateOfBirth;
    _genderController.text = userModel.gender;
    _phoneController.text = userModel.phoneNumber;
    _emailController.text = userModel.email;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignOutSuccess) {
          Get.offAllNamed(Routes.LOGIN);
        }
      },
      child: Scaffold(
        backgroundColor: Colours.white,
        appBar: const AppbarPrimary(
          title: 'My Profile',
          centerTitle: true,
          backButton: false,
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: const BoxDecoration(
                    color: Colours.blueSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      userModel.profilePic,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _phoneController.text.isEmpty
                  ? CustomFormField(
                      readOnly: true,
                      label: 'Email',
                      controller: _emailController,
                    )
                  : CustomFormField(
                      readOnly: true,
                      label: 'Phone',
                      controller: _phoneController,
                    ),
              const SizedBox(height: 24),
              CustomFormField(
                readOnly: true,
                label: 'Fullname',
                controller: _nameController,
              ),
              const SizedBox(height: 24),
              CustomFormField(
                readOnly: true,
                label: 'Gender',
                controller: _genderController,
              ),
              const SizedBox(height: 24),
              CustomFormField(
                readOnly: true,
                label: 'Date of Birth',
                controller: _dateController,
              ),
              const Spacer(),
              ButtonPrimary(
                title: 'Logout',
                onPressed: () {
                  context.read<AuthCubit>().signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
