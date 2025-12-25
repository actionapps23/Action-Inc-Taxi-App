import 'dart:math';
import 'dart:math' as math;

import 'package:action_inc_taxi_app/core/theme/app_assets.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/features/selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/cubit/auth/login_cubit.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/snackbar.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employIdController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useState(GlobalKey<FormState>());
    final screenW = MediaQuery.of(context).size.width;
    final containerWidth = screenW < 600 ? 0.9.sw : math.min(0.4.sw, 400.w);

    return BlocListener<LoginCubit, LoginState>(
      bloc: context.read<LoginCubit>(),
      listener: (context, state) {
        if (state is LoginLoading) {
          SnackBarHelper.showLoadingSnackBar(context);
        } else if (state is LoginFailure) {
          SnackBarHelper.showErrorSnackBar(
            context,
            'Incorrect credentials. Please try again.',
          );
        } else if (state is LoginSuccess) {
          SnackBarHelper.showSuccessSnackBar(context, 'Login successful!');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => SelectionScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: containerWidth,
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
                border: Border.all(color: AppColors.border),
              ),
              child: Form(
                key: formKey.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppAssets.logoPNG,
                          width: 64.w,
                          height: 48.h,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    SizedBox(height: 36.h),
                    // Employee ID Field
                    AppTextFormField(
                      labelOnTop: true,
                      controller: employIdController,
                      labelText: 'Enter ID',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your employee ID';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),
                    // Password Field
                    AppTextFormField(
                      labelOnTop: true,
                      controller: passwordController,
                      labelText: 'Enter Password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),
                    Center(
                      child: BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return AppButton(
                            text: AppConstants.loginButton,
                            onPressed: () {
                              if (formKey.value.currentState?.validate() ??
                                  false) {
                                final employeeId = employIdController.text
                                    .trim();
                                final password = passwordController.text.trim();
                                final hashPassword = sha256
                                    .convert(utf8.encode(password))
                                    .toString();
                                context.read<LoginCubit>().login(
                                  employeeId,
                                  hashPassword,
                                );
                              }
                            },
                            width: max(60.w, 80),
                            height: 44.h,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonPrimary,
                              foregroundColor: AppColors.background,
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                            isLoading: state is LoginLoading,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
