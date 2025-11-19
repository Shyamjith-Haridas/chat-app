import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextThemes {
  TextThemes._();

  static final lightTextThemes = TextTheme(
    bodySmall: TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.black,
    ),
    headlineMedium: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.black,
    ),
    headlineLarge: TextStyle(
      fontSize: 30.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.black,
    ),
  );
}
