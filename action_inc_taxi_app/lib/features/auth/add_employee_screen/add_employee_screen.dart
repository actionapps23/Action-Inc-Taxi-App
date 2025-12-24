import 'package:action_inc_taxi_app/core/theme/app_assets.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/snackbar.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/cubit/auth/add_employee_cubit.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AddEmployeeScreen extends HookWidget {
  const AddEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final roleController = useTextEditingController();
    final isAdmin = useState(false);
    final formKey = useState(GlobalKey<FormState>());

    return BlocProvider<AddEmployeeCubit>(
      create: (context) => AddEmployeeCubit(),
      child: BlocBuilder<AddEmployeeCubit, AddEmployeeState>(
        builder: (context, state) {
          final cubit = context.read<AddEmployeeCubit>();
          return FutureBuilder<String>(
            future: cubit.getNextEmployeeId(),
            builder: (context, snapshot) {
              final nextEmployeeId = snapshot.data ?? 'emp001';
              return Scaffold(
                backgroundColor: AppColors.background,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Navbar(),

                      Center(
                        child: SingleChildScrollView(
                          child: Container(
                            width: 0.4.sw,
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
                                  // Employee ID (readonly)
                                  AppTextFormField(
                                    labelOnTop: true,
                                    controller: TextEditingController(
                                      text: nextEmployeeId,
                                    ),
                                    labelText: 'Employee ID',
                                    isReadOnly: true,
                                  ),
                                  SizedBox(height: 24.h),
                                  // Name
                                  AppTextFormField(
                                    labelOnTop: true,
                                    controller: nameController,
                                    labelText: 'Name',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter employee name';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 24.h),
                                  // Password
                                  AppTextFormField(
                                    labelOnTop: true,
                                    controller: passwordController,
                                    labelText: 'Set Password',
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a password';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 24.h),
                                  // Role
                                  AppTextFormField(
                                    labelOnTop: true,
                                    controller: roleController,
                                    labelText: 'Role',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a role';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isAdmin.value,
                                        onChanged: (val) =>
                                            isAdmin.value = val ?? false,
                                      ),
                                      Text('Grant admin privileges'),
                                    ],
                                  ),
                                  SizedBox(height: 24.h),
                                  AppButton(
                                    text: 'Add Employee',
                                    onPressed: () async {
                                      if (formKey.value.currentState
                                              ?.validate() ??
                                          false) {
                                        final name = nameController.text.trim();
                                        final password = passwordController.text
                                            .trim();
                                        final role = roleController.text.trim();
                                        final hashPassword = sha256
                                            .convert(utf8.encode(password))
                                            .toString();
                                        await cubit.addEmployee(
                                          employeeId: nextEmployeeId,
                                          name: name,
                                          password: hashPassword,
                                          role: role,
                                          isAdmin: isAdmin.value,
                                        );
                                        if (context.mounted) {
                                          SnackBarHelper.showSuccessSnackBar(
                                            context,
                                            'Employee added!',
                                          );
                                          Navigator.of(context).pop();
                                        }
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
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
