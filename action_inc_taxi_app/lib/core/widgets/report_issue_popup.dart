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
import 'package:action_inc_taxi_app/cubit/auth/login_cubit.dart';
import 'package:action_inc_taxi_app/cubit/maintainance/maintainance_cubit.dart';
import 'package:action_inc_taxi_app/cubit/maintainance/maintainance_state.dart';
import 'package:action_inc_taxi_app/cubit/selection/selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';

class ReportIssuePopup extends StatefulWidget {
  final bool isEdit;
  final MaintainanceModel? maintainanceModel;

  const ReportIssuePopup({super.key, this.isEdit = false, this.maintainanceModel});

  @override
  State<ReportIssuePopup> createState() => _ReportIssuePopupState();
}

class _ReportIssuePopupState extends State<ReportIssuePopup> {
  final TextEditingController _issueController = TextEditingController();
  String? _selectedMechanic;
  final List<String> attachmentUrls = [];
  List<PlatformFile> _selectedFiles = [];
  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.maintainanceModel != null) {
      _issueController.text = widget.maintainanceModel!.description;
      attachmentUrls.addAll(widget.maintainanceModel!.attachmentUrls ?? []);
      if (widget.maintainanceModel!.assignedTo != null &&
          widget.maintainanceModel!.assignedTo!.isNotEmpty) {
        _selectedMechanic = widget.maintainanceModel!.assignedTo;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final SelectionCubit selectionCubit = context.read<SelectionCubit>();
    final LoginCubit loginCubit = context.read<LoginCubit>();
    final LoginSuccess loginState = loginCubit.state as LoginSuccess;

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
                      ResponsiveText(
                        widget.isEdit ? "Update maintenance request" : "Report Issues",
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
                        label: widget.isEdit ? "Update Problem Description" : "Write Problem Description",
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
                                  if(widget.isEdit){
                                    
                                    

                                  
                                  }
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
                            child: ResponsiveText(
                              widget.isEdit ? "Update Pic / Files" : "Upload Pic / Files",
                              style: AppTextStyles.bodyExtraSmall.copyWith(
                                color: AppColors.textHint,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_selectedFiles.isNotEmpty || attachmentUrls.isNotEmpty) ...[
                        Spacing.vSmall,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Show local files
                            ..._selectedFiles.map((file) {
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
                                      child: ResponsiveText(
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
                            // Show cloud attachments
                            ...attachmentUrls.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final url = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: Spacing.vSmall.height ?? 6,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: ResponsiveText(
                                        'image${idx + 1}',
                                        style: AppTextStyles.bodyExtraSmall
                                            .copyWith(fontSize: 3.sp),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Spacing.hSmall,
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                        url,
                                        width: Spacing.vLarge.height ?? 32,
                                        height: Spacing.vLarge.height ?? 32,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Icon(
                                          Icons.broken_image,
                                          color: AppColors.error,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    Spacing.hSmall,
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          attachmentUrls.removeAt(idx);
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
                            }),
                          ],
                        ),
                      ],
                      Spacing.vLarge,
                     if(loginState.user.isAdmin)...[
                       InventoryField(
                        label: widget.isEdit ? "Update Mechanic" : "Assign Mechanic",
                        child: AppDropdown<String>(
                          value: _selectedMechanic,
                          labelText: widget.isEdit ? "Update Mechanic" : "Select Mechanic",
                          onChanged: (value) {
                            setState(() {
                              _selectedMechanic = value;
                            });
                          },
                          items: AppConstants.mechanics
                              .map(
                                (mechanic) => DropdownMenuItem(
                                  value: mechanic,
                                  child: ResponsiveText(
                                    mechanic,
                                    style: AppTextStyles.bodyExtraSmall,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Spacing.vLarge,
                     ],
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              onPressed: () {
                                if (_issueController.text.isNotEmpty &&
                                    (_selectedMechanic != null || !loginState.user.isAdmin)) {
                                 
                                 if(!widget.isEdit){
                                   final maintainanceRequest = MaintainanceModel(
                                    taxiId: selectionCubit.state.taxiNo,
                                    taxiPlateNumber: selectionCubit.state.taxiPlateNo,
                                    taxiRegistrationNumber: selectionCubit.state.regNo,
                                    inspectedBy: loginState.user.name,
                                    assignedTo: _selectedMechanic ?? '',
                                    id: DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                    title: title,
                                    description:
                                        _issueController.text,
                                    date: DateTime.now(),
                                    lastUpdatedBy: loginState.user.name,
                                    lastUpdatedAt: DateTime.now(),
                                  );

                                   maintainanceCubit.addMaintainanceRequest(
                                    maintainanceRequest,
                                    _selectedFiles,
                                  );
                                 }
                                 else{
                                  maintainanceCubit.updateMaintainanceRequest(
                                    widget.maintainanceModel!.copyWith(
                                      attachmentUrls: attachmentUrls,
                                      description: _issueController.text,
                                      assignedTo: _selectedMechanic ?? '',
                                    ),
                                    files: _selectedFiles,
                                  );
                                 }
                                  Navigator.of(context).pop();
                                } else {
                                  SnackBarHelper.showErrorSnackBar(
                                    context,
                                    AppConstants.fillAllFieldsError,
                                  );
                                }
                              },
                              text: state is MaintainanceLoading
                                  ? (widget.isEdit ? "Updating..." : "Submitting...")
                                  : (widget.isEdit ? "Update" : "Submit"),

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

  String get title {
    final SelectionCubit selectionCubit = context.read<SelectionCubit>();
    final plateNo = selectionCubit.state.taxiPlateNo;
    final regNo = selectionCubit.state.regNo;
    final taxiNo = selectionCubit.state.taxiNo;

    if (plateNo.isNotEmpty && regNo.isNotEmpty) {
      return "Issue Report: Taxi Plate No. $plateNo | Reg No. $regNo";
    } else if (plateNo.isNotEmpty) {
      return "Issue Report: Taxi Plate No. $plateNo";
    } else if (regNo.isNotEmpty) {
      return "Issue Report: Reg No. $regNo";
    } else if (taxiNo.isNotEmpty) {
      return "Issue Report: Taxi No. $taxiNo";
    } else {
      return "Issue Report: Unknown Taxi";
    }
  }

}
