import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_spaces.dart';
import 'package:chat_app/core/constants/app_texts.dart';
import 'package:chat_app/core/routes/route_names.dart';
import 'package:chat_app/features/auth/login/presentation/viewmodel/login_viewm_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late LoginViewModel _loginViewModel;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginViewModel = GetIt.I<LoginViewModel>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> onLoginPressed() async {
    FocusScope.of(context).unfocus();
    final success = await _loginViewModel.login();

    if (success) {
      // Navigate to login or home screen after success
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login successfully!')));
        Navigator.pushNamed(context, RouteNames.home);
      }
    } else if (_loginViewModel.generalError != null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_loginViewModel.generalError!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _loginViewModel,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSpaces.defaultPadding.h),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppTexts.login,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(height: AppSpaces.spaceBwItems.h),

                      const Text(AppTexts.loginAccountSubText),
                      SizedBox(height: AppSpaces.spaceSectionDouble.h),

                      Form(
                        key: _formKey,
                        child: Column(
                          spacing: AppSpaces.spaceBwInputs,
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: AppTexts.emailHint,
                                errorText: _loginViewModel.emailError,
                              ),
                              onChanged: _loginViewModel.onEmailChanged,
                            ),

                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: AppTexts.passwordHint,
                                errorText: _loginViewModel.passwordError,
                              ),
                              onChanged: _loginViewModel.onPasswordChanged,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpaces.spaceSectionDouble.h),

                      SizedBox(
                        height: 60.h,
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: _loginViewModel.isLoading
                              ? null
                              : onLoginPressed,
                          child: _loginViewModel.isLoading
                              ? const CircularProgressIndicator(
                                  color: AppColors.white,
                                )
                              : Text(
                                  AppTexts.login,
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(color: AppColors.white),
                                ),
                        ),
                      ),
                      SizedBox(height: AppSpaces.defaultSpacing.h),

                      Text(
                        AppTexts.dontAccount,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: AppColors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteNames.signup);
                        },
                        child: Text(
                          AppTexts.signup,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
