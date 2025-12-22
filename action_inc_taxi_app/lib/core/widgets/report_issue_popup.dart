import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/models/maintainance_model.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/form/app_dropdown.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/inventory_field_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/snackbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/cubit/maintainance/maintainance_cubit.dart';
import 'package:action_inc_taxi_app/cubit/maintainance/maintainance_state.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportIssuePopup extends StatefulWidget {
  const ReportIssuePopup({super.key});

  @override
  State<ReportIssuePopup> createState() => _ReportIssuePopupState();
}

class _ReportIssuePopupState extends State<ReportIssuePopup> {
  final TextEditingController _issueController = TextEditingController();
  String? _selectedMechanic;
  List<PlatformFile> _selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    final double maxWidth = MediaQuery.of(context).size.width * 0.95;
    final double dialogWidth = maxWidth > 500 ? 500 : maxWidth;
    final MaintainanceCubit maintainanceCubit = context
        .read<MaintainanceCubit>();
    return BlocBuilder<MaintainanceCubit, MaintainanceState>(
      bloc: maintainanceCubit,
      builder: (context, state) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: dialogWidth,
              padding: EdgeInsets.all(Spacing.vLarge.height ?? 24),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Report Issues",
                        style: AppTextStyles.bodyExtraSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.close, color: AppColors.scaffold),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacing.vMedium,
                      InventoryField(
                        label: "Write Problem Description",
                        child: AppTextFormField(
                          controller: _issueController,
                          maxLines: 4,
                          labelOnTop: true,
                        ),
                      ),
                      Spacing.vMedium,
                      Row(
                        children: [
                          Icon(
                            Icons.upload_file,
                            color: AppColors.textHint,
                            size: 20,
                          ),
                          Spacing.hSmall,
                          InkWell(
                            onTap: () async {
                              try {
                                FilePickerResult? result = await FilePicker
                                    .platform
                                    .pickFiles(
                                      allowMultiple: true,
                                      withData: kIsWeb,
                                    );
                                if (result != null && result.files.isNotEmpty) {
                                  setState(() {
                                    final existingNames = _selectedFiles
                                        .map((f) => f.name)
                                        .toSet();
                                    final newFiles = result.files
                                        .where(
                                          (f) =>
                                              !existingNames.contains(f.name),
                                        )
                                        .toList();
                                    _selectedFiles = [
                                      ..._selectedFiles,
                                      ...newFiles,
                                    ];
                                  });
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  SnackBarHelper.showErrorSnackBar(
                                    context,
                                    AppConstants.filePickerError,
                                  );
                                }
                              }
                            },
                            child: Text(
                              "Upload Pic / Files",
                              style: AppTextStyles.bodyExtraSmall.copyWith(
                                color: AppColors.textHint,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_selectedFiles.isNotEmpty) ...[
                        Spacing.vSmall,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _selectedFiles.map((file) {
                            final isImage =
                                file.extension != null &&
                                [
                                  'jpg',
                                  'jpeg',
                                  'png',
                                  'gif',
                                  'bmp',
                                  'webp',
                                ].contains(file.extension!.toLowerCase());
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: Spacing.vSmall.height ?? 6,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      file.name,
                                      style: AppTextStyles.bodyExtraSmall
                                          .copyWith(fontSize: 3.sp),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Spacing.hSmall,
                                  if (isImage && file.bytes != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.memory(
                                        file.bytes!,
                                        width: Spacing.vLarge.height ?? 32,
                                        height: Spacing.vLarge.height ?? 32,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  else
                                    Icon(
                                      Icons.insert_drive_file,
                                      color: AppColors.success,
                                      size: 18,
                                    ),

                                  Spacing.hSmall,
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedFiles.removeWhere(
                                          (f) => f.name == file.name,
                                        );
                                      });
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      Spacing.vLarge,
                      InventoryField(
                        label: "Assign Mechanic",
                        child: AppDropdown<String>(
                          value: _selectedMechanic,
                          labelText: "Select Mechanic",
                          onChanged: (value) {
                            setState(() {
                              _selectedMechanic = value;
                            });
                          },
                          items: AppConstants.mechanics
                              .map(
                                (mechanic) => DropdownMenuItem(
                                  value: mechanic,
                                  child: Text(
                                    mechanic,
                                    style: AppTextStyles.bodyExtraSmall,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Spacing.vLarge,
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              onPressed: () {
                                if (_issueController.text.isNotEmpty &&
                                    _selectedMechanic != null) {
                                  final maintainanceRequest = MaintainanceModel(
                                    taxiId: '123',
                                    fleetId: 'fleet_001',
                                    inspectedBy: "Muneeb Masood",
                                    assignedTo: "Masood Saeed",
                                    id: DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                    title: _issueController.text,
                                    description:
                                        "Assigned to mechanic: $_selectedMechanic",
                                    date: DateTime.now(),
                                    attachmentUrls: _selectedFiles
                                        .map((file) => file.name)
                                        .toList(),
                                  );
                                  maintainanceCubit.addMaintainanceRequest(
                                    maintainanceRequest,
                                  );
                                  Navigator.of(context).pop();
                                } else {
                                  SnackBarHelper.showErrorSnackBar(
                                    context,
                                    AppConstants.fillAllFieldsError,
                                  );
                                }
                              },
                              text: state is MaintainanceLoading
                                  ? "Submitting..."
                                  : "Submit",

                              backgroundColor: AppColors.buttonPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
