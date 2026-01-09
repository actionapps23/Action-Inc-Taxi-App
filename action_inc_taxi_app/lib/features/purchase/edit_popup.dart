import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/utils/device_utils.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditFieldPopup extends StatefulWidget {
  final String title;
  final String label;
  final String initialValue;
  final String hintText;
  final void Function(String) onSave;
  final String saveButtonText;

  const EditFieldPopup({
    super.key,
    required this.title,
    required this.label,
    required this.initialValue,
    required this.hintText,
    required this.onSave,
    this.saveButtonText = 'Save',
  });

  @override
  State<EditFieldPopup> createState() => _EditFieldPopupState();
}

class _EditFieldPopupState extends State<EditFieldPopup> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceUtils = DeviceUtils(context);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: deviceUtils.getResponsiveWidth().sw,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                child: ResponsiveText(
                  widget.title,
                  style: AppTextStyles.bodyExtraSmall
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                child: AppTextFormField(
                  controller: _controller,
                  labelText: widget.label,
                  hintText: widget.hintText,
                  labelOnTop: true,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const ResponsiveText('Cancel'),
                  ),
                  SizedBox(width: 8.w),
                  AppButton(
                    text: widget.saveButtonText,
                    onPressed: () {
                      widget.onSave(_controller.text.trim());
                      Navigator.of(context).pop();
                    },
                    height: 36.h,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
