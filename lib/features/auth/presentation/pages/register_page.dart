import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

import 'package:simple_login_firebase/core/utils/toast_alert.dart';
import 'package:simple_login_firebase/features/auth/presentation/cubit/auth_cubit.dart';

import '../../../../core/common/widgets/widgets.dart';
import '../../../../core/res/colours.dart';
import '../../../../core/res/typhography_style.dart';
import '../../../../core/routes/routes.dart';
import '../../data/models/user_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  File? _image;
  bool isLoading = false;
  String selectedGender = 'Male';
  DateTime _selectedDate = DateTime.now();
  String email = Get.arguments['email'];

  Future _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          setState(() {
            isLoading = true;
          });
        }

        if (state is RegisterSuccess) {
          setState(() {
            isLoading = false;
          });

          Get.toNamed(Routes.PROFILE, arguments: {
            'userModel': state.userModel,
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colours.white,
        appBar: const AppbarPrimary(
          title: 'Register',
          backButton: false,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      _image == null
                          ? Container(
                              height: 120,
                              width: 120,
                              margin: const EdgeInsets.only(top: 12),
                              decoration: const BoxDecoration(
                                color: Colours.blueSecondary,
                                shape: BoxShape.circle,
                              ),
                            )
                          : Container(
                              height: 120,
                              width: 120,
                              margin: const EdgeInsets.only(top: 12),
                              decoration: const BoxDecoration(
                                color: Colours.blueSecondary,
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 100,
                        child: OutlineButtonPrimary(
                          title: 'Change Photo',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ImageItem(
                                        onTap: () {
                                          _getImage(ImageSource.camera);
                                          Get.back();
                                        },
                                        icon: Icons.camera_alt_outlined,
                                        title: 'Take Picture',
                                      ),
                                      const SizedBox(height: 16),
                                      ImageItem(
                                        onTap: () {
                                          _getImage(ImageSource.gallery);
                                          Get.back();
                                        },
                                        icon: Icons.image,
                                        title: 'Gallery',
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                CustomFormField(
                  label: 'Fullname',
                  controller: _nameController,
                ),
                const SizedBox(height: 24),
                CustomFormField(
                  onTap: () {
                    _selectDate(context);
                  },
                  readOnly: true,
                  label: 'Date of Birth',
                  controller: _dateController,
                ),
                const SizedBox(height: 24),
                DropdownButton<String>(
                  isExpanded: true,
                  value: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                  underline: Container(
                    height: 1,
                    color: Colours.grey,
                  ),
                  items: <String>['Male', 'Female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 48),
                ButtonPrimary(
                  isLoading: isLoading,
                  title: 'Register',
                  onPressed: () {
                    UserModel userModel = UserModel(
                      name: _nameController.text.trim(),
                      dateOfBirth: _dateController.text.trim(),
                      gender: selectedGender,
                      email: email,
                      profilePic: "",
                      createdAt: "",
                      phoneNumber: "",
                      uid: "",
                    );

                    if (_image != null) {
                      context
                          .read<AuthCubit>()
                          .signUp(userModel: userModel, profilePic: _image!);
                    } else {
                      ToastAlert.showToastWarningBottom(
                          title: 'Failed',
                          message: "Please upload your profile photo");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageItem extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;

  const ImageItem({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colours.bluePrimary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colours.white,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TypographyStyle.regular16.copyWith(
                color: Colours.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
