import 'dart:convert';

import 'package:action_inc_taxi_app/core/routes/app_routes.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/utils/device_utils.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/snackbar.dart';
import 'package:action_inc_taxi_app/cubit/auth/login_cubit.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';

class ChangePasswordScreen extends HookWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPassController = useTextEditingController();
    final newPassController = useTextEditingController();
    final confirmPassController = useTextEditingController();
    final formKey = useState(GlobalKey<FormState>());
    final loginCubit = context.read<LoginCubit>();
    final DeviceUtils deviceUtils = DeviceUtils(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Navbar(),
            Center(
              child: BlocListener<LoginCubit, LoginState>(
                bloc: loginCubit,
                listener: (context, state) {
                  if (state is UpdatePasswordFailure) {
                    SnackBarHelper.showErrorSnackBar(context, state.error);
                  } else if (state is UpdatePasswordSuccess) {
                    SnackBarHelper.showSuccessSnackBar(
                      context,
                      'Password updated successfully',
                    );
                    Navigator.pushNamed(context, AppRoutes.selection);
                  }
                },
                child: SingleChildScrollView(
                  child: Container(
                    width: deviceUtils.getResponsiveWidth().sw,
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 24.h,
                    ),
                    constraints: BoxConstraints(maxWidth: 400.w),
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
                          SizedBox(height: 36.h),
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) => ResponsiveText(
                              state is UpdatePasswordLoading
                                  ? 'Changing Password...'
                                  : 'Change Password',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          AppTextFormField(
                            labelOnTop: true,
                            controller: currentPassController,
                            labelText: 'Current Password',
                            hintText: 'Enter current password',
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your current password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24.h),
                          AppTextFormField(
                            labelOnTop: true,
                            controller: newPassController,
                            labelText: 'New Password',
                            hintText: 'Enter new password',
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a new password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24.h),
                          AppTextFormField(
                            labelOnTop: true,
                            controller: confirmPassController,
                            labelText: 'Confirm New Password',
                            hintText: 'Re-enter new password',
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your new password';
                              }
                              if (value != newPassController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 32.h),
                          AppButton(
                            text: 'Change Password',
                            onPressed: () async {
                              if (formKey.value.currentState?.validate() ??
                                  false) {
                                final currentPassword = currentPassController
                                    .text
                                    .trim();
                                final newPassword = newPassController.text
                                    .trim();
                                await context
                                    .read<LoginCubit>()
                                    .updateEmployeePassword(
                                      sha256
                                          .convert(utf8.encode(currentPassword))
                                          .toString(),
                                      sha256
                                          .convert(utf8.encode(newPassword))
                                          .toString(),
                                    );
                              }
                            },
                            width: 60.w,
                            height: 44.h,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonPrimary,
                              foregroundColor: AppColors.background,
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
