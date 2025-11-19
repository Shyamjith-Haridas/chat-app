import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_spaces.dart';
import 'package:chat_app/core/constants/app_texts.dart';
import 'package:chat_app/features/auth/signup/presentation/viewmodel/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late SignupViewModel _signupViewModel;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _signupViewModel = GetIt.I<SignupViewModel>();
  }

  @override
  void dispose() {
    _signupViewModel.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _onSignupPressed() async {
    FocusScope.of(context).unfocus(); // close keyboard
    final success = await _signupViewModel.signUp();
    if (success) {
      // Navigate to login or home screen after success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        Navigator.pop(context); // Go back to login
      }
    } else if (_signupViewModel.generalError != null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_signupViewModel.generalError!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    AppTexts.createAccountHeaderText,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: AppSpaces.spaceBwItems.h),

                  Text(
                    AppTexts.createAccountSubText,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: AppColors.grey),
                  ),
                  SizedBox(height: AppSpaces.spaceSectionDouble.h),

                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: AppSpaces.spaceBwInputs,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: AppTexts.nameHint,
                            errorText: _signupViewModel.nameError,
                          ),
                          onChanged: _signupViewModel.onNameChanged,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: AppTexts.emailHint,
                            errorText: _signupViewModel.emailError,
                          ),
                          onChanged: _signupViewModel.onEmailChanged,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: AppTexts.passwordHint,
                            errorText: _signupViewModel.passwordError,
                          ),
                          onChanged: _signupViewModel.onPasswordChanged,
                        ),
                        TextFormField(
                          controller: _confirmPassController,
                          decoration: InputDecoration(
                            hintText: AppTexts.confirmPasswordHint,
                            errorText: _signupViewModel.confirmPasswordError,
                          ),
                          onChanged: _signupViewModel.onConfirmPasswordChanged,
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
                          borderRadius: BorderRadiusGeometry.circular(12.r),
                        ),
                      ),
                      onPressed: _signupViewModel.isLoading
                          ? null
                          : _onSignupPressed,
                      child: Text(
                        AppTexts.register,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpaces.defaultSpacing.h),

                  Text(
                    AppTexts.alreadyAccount,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: AppColors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppTexts.login,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
