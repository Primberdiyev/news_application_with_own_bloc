import 'package:flutter/material.dart';
import 'package:news_application/features/utils/app_colors.dart';

class AppTextStyles {
  static TextStyle get body16W400 => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      );
  static TextStyle get body14W400 => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.authorColor,
      );
  static TextStyle get head24W600 => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  static TextStyle get head32W600 => TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      );
  static TextStyle get head20W600 => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );
  static TextStyle get body18W400 => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      );
}
