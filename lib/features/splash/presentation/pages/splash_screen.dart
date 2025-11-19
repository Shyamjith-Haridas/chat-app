import 'dart:async';

import 'package:chat_app/core/constants/app_images.dart';
import 'package:chat_app/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splashFunction();
  }

  void splashFunction() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, RouteNames.authWrapper);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(AppImages.splashIcon, height: 300.h)),
    );
  }
}
