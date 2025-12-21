import 'package:action_inc_taxi_app/core/constants/app_constants.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/widgets/form/app_dropdown.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/inventory_field_widget.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/snackbar.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class ReportIssuePopup extends StatefulWidget {
  const ReportIssuePopup({
    super.key,
  });

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
                    style: AppTextStyles.button.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close, color: Colors.white),
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
                      Icon(Icons.upload_file, color: Colors.white70, size: 20),
                      Spacing.hSmall,
                      InkWell(
                        onTap: () async {
                          try {
                            FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, withData: kIsWeb);
                            if (result != null && result.files.isNotEmpty) {
                              setState(() {
                                // Append new files, avoid duplicates by name
                                final existingNames = _selectedFiles.map((f) => f.name).toSet();
                                final newFiles = result.files.where((f) => !existingNames.contains(f.name)).toList();
                                _selectedFiles = [..._selectedFiles, ...newFiles];
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
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedFiles.isNotEmpty) ...[
                    Spacing.vSmall,
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _selectedFiles.map((file) {
                          final isImage = file.extension != null && ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(file.extension!.toLowerCase());
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              children: [
                                if (isImage && file.bytes != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.memory(
                                      file.bytes!,
                                      width: 32,
                                      height: 32,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else
                                  Icon(Icons.insert_drive_file, color: Colors.greenAccent, size: 18),
                                Spacing.hSmall,
                                Flexible(
                                  child: Text(
                                    file.name,
                                    style: TextStyle(color: Colors.white, fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacing.hSmall,
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedFiles.remove(file);
                                    });
                                  },
                                  child: Icon(Icons.close, color: Colors.redAccent, size: 18),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
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
                          .map((m) => DropdownMenuItem(
                                value: m,
                                child: Text(m, style: TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                    ),
                  ),
                  Spacing.vLarge,
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_issueController.text.isNotEmpty && _selectedMechanic != null) {


                          Navigator.of(context).pop();
                        }

                        else {
                          SnackBarHelper.showErrorSnackBar(
                            context,
                            AppConstants.fillAllFieldsError,
                          );
                        }
                      },
                      child: Text(
                        "Submit",
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.buttonText,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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