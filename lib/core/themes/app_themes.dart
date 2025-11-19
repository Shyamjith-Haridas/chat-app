import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/themes/custom_themes/text_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    textTheme: TextThemes.lightTextThemes,
    inputDecorationTheme: TextFieldDecorationThemes.lightInputTheme,
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.white,
    ),
  );
}

class TextFieldDecorationThemes {
  TextFieldDecorationThemes._();

  static final lightInputTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.withValues(alpha: 0.2),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10.r),
    ),
  );
}
