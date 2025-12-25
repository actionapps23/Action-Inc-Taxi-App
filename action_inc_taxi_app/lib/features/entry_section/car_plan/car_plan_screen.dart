import 'package:action_inc_taxi_app/core/models/rent.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:action_inc_taxi_app/features/entry_section/car_plan/action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CarPlanScreen extends StatefulWidget {
  const CarPlanScreen({super.key});

  @override
  State<CarPlanScreen> createState() => _CarPlanScreenState();
}

class _CarPlanScreenState extends State<CarPlanScreen> {
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final monthsController = TextEditingController();
  final extraDaysController = TextEditingController(text: '03');

  // Default History data
  final List<DefaultHistoryEntry> defaultHistory = [];

  @override
  void initState() {
    super.initState();
    // Set default dates
    startDateController.text = '15/02/2024';
    endDateController.text = '15/02/2024';
    monthsController.text = '03 Months';
    extraDaysController.text = '03';
    _updateMonthsCount();

    // Add sample default history entries
    defaultHistory.addAll([
      DefaultHistoryEntry(
        name: 'Arunav Rahul',
        role: 'Admin',
        description: 'Driver was sick',
        date: '12 Mar, 2024',
      ),
    ]);
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    monthsController.dispose();
    extraDaysController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  Future<void> _pickDateForController(
    TextEditingController controller, {
    DateTime? initial,
  }) async {
    final now = DateTime.now();
    final init = initial ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = _formatDate(picked);
      _updateMonthsCount();
    }
  }

  void _updateMonthsCount() {
    final startUtc = _parseDateToUtcMs(startDateController.text);
    final endUtc = _parseDateToUtcMs(endDateController.text);
    final months = Rent.computeMonthsCountFromTimestamps(startUtc, endUtc);
    final formatted = months.toString().padLeft(2, '0');
    monthsController.text = '$formatted Months';
  }

  int? _parseDateToUtcMs(String input) {
    try {
      if (input.trim().isEmpty) return null;
      try {
        final df = DateFormat('dd/MM/yyyy');
        return df.parse(input).toUtc().millisecondsSinceEpoch;
      } catch (_) {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  void _addDefault() {
    showDialog(
      context: context,
      builder: (context) => _AddDefaultDialog(
        onSave: (entry) {
          setState(() {
            defaultHistory.add(entry);
          });
        },
      ),
    );
  }

  void _editDefault(int index) {
    showDialog(
      context: context,
      builder: (context) => _AddDefaultDialog(
        initialEntry: defaultHistory[index],
        onSave: (entry) {
          setState(() {
            defaultHistory[index] = entry;
          });
        },
      ),
    );
  }

  void _deleteDefault(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const ResponsiveText(
          'Delete Default',
          style: TextStyle(color: Colors.white),
        ),
        content: const ResponsiveText(
          'Are you sure you want to delete this default entry?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const ResponsiveText(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                defaultHistory.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const ResponsiveText(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car Plan Category
          ResponsiveText(
            'Car Plan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  controller: startDateController,
                  labelText: 'Start date',
                  hintText: 'DD/MM/YYYY',
                  isReadOnly: true,
                  suffix: Icon(
                    Icons.calendar_today,
                    color: Colors.white54,
                    size: 18,
                  ),
                  onTap: () => _pickDateForController(startDateController),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: AppTextFormField(
                  controller: endDateController,
                  labelText: 'End date',
                  hintText: 'DD/MM/YYYY',
                  isReadOnly: true,
                  suffix: Icon(
                    Icons.calendar_today,
                    color: Colors.white54,
                    size: 18,
                  ),
                  onTap: () => _pickDateForController(endDateController),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  controller: monthsController,
                  labelText: 'No. of Months',
                  hintText: '0 Months',
                  isReadOnly: true,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: AppTextFormField(
                  controller: extraDaysController,
                  labelText: 'Extra Days',
                  hintText: '0 Days',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Validate extra days input
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),

          // Default History Category
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ResponsiveText(
                'Default History',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              AppButton(
                text: '+ Add Default',
                onPressed: _addDefault,
                backgroundColor: AppColors.primary,
                textColor: Colors.white,
                width: 120.w,
                height: 36.h,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Default History List
          if (defaultHistory.isEmpty)
            Container(
              padding: EdgeInsets.all(24.h),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: Center(
                child: ResponsiveText(
                  'No default history entries yet',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ),
            )
          else
            ...defaultHistory.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResponsiveText(
                                item.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              ResponsiveText(
                                item.role,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 20,
                              ),
                              onPressed: () => _editDefault(index),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                            SizedBox(width: 8.w),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () => _deleteDefault(index),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ResponsiveText(
                      item.description,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 8.h),
                    ResponsiveText(
                      item.date,
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        ResponsiveText(
                          'Attachments: ',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Icon(Icons.picture_as_pdf, color: Colors.red, size: 18),
                        SizedBox(width: 8.w),
                        Icon(Icons.image, color: Colors.blue, size: 18),
                      ],
                    ),
                  ],
                ),
              );
            }),

          SizedBox(height: 32.h),

          // Action Buttons
          ActionButtons(
            onSubmit: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: ResponsiveText('Car Plan submitted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            onCancel: () {
              Navigator.pop(context);
            },
          ),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

// Default History Entry Model
class DefaultHistoryEntry {
  final String name;
  final String role;
  final String description;
  final String date;
  final List<String> attachments;

  DefaultHistoryEntry({
    required this.name,
    required this.role,
    required this.description,
    required this.date,
    this.attachments = const [],
  });
}

// Add/Edit Default Dialog
class _AddDefaultDialog extends StatefulWidget {
  final DefaultHistoryEntry? initialEntry;
  final Function(DefaultHistoryEntry) onSave;

  const _AddDefaultDialog({this.initialEntry, required this.onSave});

  @override
  State<_AddDefaultDialog> createState() => _AddDefaultDialogState();
}

class _AddDefaultDialogState extends State<_AddDefaultDialog> {
  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialEntry != null) {
      nameController.text = widget.initialEntry!.name;
      roleController.text = widget.initialEntry!.role;
      descriptionController.text = widget.initialEntry!.description;
      dateController.text = widget.initialEntry!.date;
    } else {
      final today = DateTime.now();
      dateController.text =
          '${today.day} ${_getMonthName(today.month)}, ${today.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text =
            '${picked.day} ${_getMonthName(picked.month)}, ${picked.year}';
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    roleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardBackground,
      child: Container(
        padding: EdgeInsets.all(24.w),
        constraints: BoxConstraints(maxWidth: 500.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ResponsiveText(
                widget.initialEntry == null ? 'Add Default' : 'Edit Default',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24.h),
              AppTextFormField(
                controller: nameController,
                labelText: 'Name',
                hintText: 'Enter name',
                labelOnTop: true,
              ),
              SizedBox(height: 16.h),
              AppTextFormField(
                controller: roleController,
                labelText: 'Role',
                hintText: 'Enter role',
                labelOnTop: true,
              ),
              SizedBox(height: 16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ResponsiveText(
                      'Description',
                      style: TextStyle(
                        color: AppColors.textHint,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    style: TextStyle(color: AppColors.textHint, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Enter description',
                      hintStyle: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 14,
                      ),
                      fillColor: AppColors.background,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.border,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.border,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              AppTextFormField(
                controller: dateController,
                labelText: 'Date',
                hintText: 'Select date',
                labelOnTop: true,
                isReadOnly: true,
                suffix: Icon(
                  Icons.calendar_today,
                  color: Colors.white54,
                  size: 18,
                ),
                onTap: _pickDate,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: ResponsiveText(
                      'Cancel',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  AppButton(
                    text: 'Save',
                    onPressed: () {
                      if (nameController.text.trim().isEmpty ||
                          roleController.text.trim().isEmpty ||
                          descriptionController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: ResponsiveText('Please fill all fields'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      widget.onSave(
                        DefaultHistoryEntry(
                          name: nameController.text.trim(),
                          role: roleController.text.trim(),
                          description: descriptionController.text.trim(),
                          date: dateController.text.trim(),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                    width: 80.w,
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
