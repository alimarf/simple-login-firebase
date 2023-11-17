import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/colours.dart';
import '../res/typhography_style.dart';



class ToastAlert {
  const ToastAlert._();

  static void showToastWarningBottom(
      {required String title, required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.transparent,
        messageText: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colours.errorDark,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TypographyStyle.semi16.copyWith(
                  color: Colours.white,
                ),
              ),
              Text(
                message,
                style: TypographyStyle.regular12.copyWith(
                  color: Colours.white,
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showToastSuccessTop({required String  title, required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.transparent,
        messageText: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colours.green,
          ),
          child: Text(
            title,
            style: TypographyStyle.semi16.copyWith(
              color: Colours.white,
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  
}
