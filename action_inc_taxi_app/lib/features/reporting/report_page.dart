import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'report_cubit.dart';
import 'report_state.dart';
import 'models/report_row.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportCubit(),
      child: const ReportView(),
    );
  }
}

class ReportView extends StatefulWidget {
  const ReportView({Key? key}) : super(key: key);

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  final List<TextEditingController> _plateControllers = [];
  final List<TextEditingController> _modelControllers = [];
  final List<TextEditingController> _driverControllers = [];
  final List<TextEditingController> _cleanControllers = [];
  final List<TextEditingController> _remarksControllers = [];
  final List<DateTime> _dates = [];
  final TextEditingController _recipientController = TextEditingController();

  @override
  void dispose() {
    for (final c in _plateControllers) {
      c.dispose();
    }
    for (final c in _modelControllers) {
      c.dispose();
    }
    for (final c in _driverControllers) {
      c.dispose();
    }
    for (final c in _cleanControllers) {
      c.dispose();
    }
    for (final c in _remarksControllers) {
      c.dispose();
    }
    _recipientController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // start with one empty row for convenience
    _addEmptyRow();
  }

  void _addEmptyRow() {
    setState(() {
      _plateControllers.add(TextEditingController());
      _modelControllers.add(TextEditingController());
      _driverControllers.add(TextEditingController());
      _cleanControllers.add(TextEditingController());
      _remarksControllers.add(TextEditingController());
      _dates.add(DateTime.now());
    });
  }

  void _collectRowsAndPushToCubit() {
    final cubit = context.read<ReportCubit>();
    final List<ReportRow> rows = [];
    for (int i = 0; i < _plateControllers.length; i++) {
      final row = ReportRow(
        date: _dates[i],
        plateNumber: _plateControllers[i].text,
        vehicleModel: _modelControllers[i].text,
        driverName: _driverControllers[i].text,
        cleanliness: _cleanControllers[i].text,
        remarks: _remarksControllers[i].text,
      );
      rows.add(row);
    }
    cubit.setRows(rows);
  }

  String _getStatusMessage(ReportStatus status, String? error) {
    switch (status) {
      case ReportStatus.initial:
        return 'Ready to generate report';
      case ReportStatus.generating:
        return 'Generating PDF...';
      case ReportStatus.ready:
        return 'PDF generated successfully! Click Preview or Upload.';
      case ReportStatus.uploading:
        return 'Uploading to Firebase Storage...';
      case ReportStatus.uploaded:
        return 'PDF uploaded! Enter recipient email and send.';
      case ReportStatus.sending:
        return 'Sending email via AWS SES...';
      case ReportStatus.sent:
        return 'Email sent successfully!';
      case ReportStatus.error:
        return 'Error: ${error ?? "Unknown error"}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const Navbar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Inspection Report',
                          style: AppTextStyles.bodyExtraSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppButton(
                          text: '+ Add Row',
                          onPressed: _addEmptyRow,
                          backgroundColor: AppColors.buttonPrimary,
                          textColor: AppColors.buttonText,
                          width: 120,
                        ),
                      ],
                    ),
                    Spacing.vStandard,
                    Expanded(
                      child: ListView.builder(
                        itemCount: _plateControllers.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: _dates[index],
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        );
                                        if (picked != null) {
                                          setState(
                                            () => _dates[index] = picked,
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white10,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                              color: Colors.white70,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${_dates[index].toIso8601String().split('T').first}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _plateControllers.removeAt(index);
                                          _modelControllers.removeAt(index);
                                          _driverControllers.removeAt(index);
                                          _cleanControllers.removeAt(index);
                                          _remarksControllers.removeAt(index);
                                          _dates.removeAt(index);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacing.vSmall,
                                AppTextFormField(
                                  labelOnTop: true,
                                  labelText: 'Plate Number',
                                  controller: _plateControllers[index],
                                ),
                                Spacing.vSmall,
                                AppTextFormField(
                                  labelOnTop: true,
                                  labelText: 'Vehicle Model / Type',
                                  controller: _modelControllers[index],
                                ),
                                Spacing.vSmall,
                                AppTextFormField(
                                  labelOnTop: true,
                                  labelText: 'Driver Name',
                                  controller: _driverControllers[index],
                                ),
                                Spacing.vSmall,
                                AppTextFormField(
                                  labelOnTop: true,
                                  labelText: 'Cleanliness',
                                  controller: _cleanControllers[index],
                                ),
                                Spacing.vSmall,
                                AppTextFormField(
                                  labelOnTop: true,
                                  labelText: 'Remarks',
                                  controller: _remarksControllers[index],
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    Spacing.vMedium,
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: AppButton(
                            text: 'Generate PDF',
                            onPressed: () async {
                              _collectRowsAndPushToCubit();
                              await context.read<ReportCubit>().generatePdf();
                            },
                            backgroundColor: AppColors.buttonPrimary,
                            textColor: AppColors.buttonText,
                            height: 48,
                          ),
                        ),
                        Spacing.hMedium,
                        Expanded(
                          child: AppButton(
                            text: 'Preview PDF',
                            onPressed: () async {
                              await context.read<ReportCubit>().previewPdf();
                            },
                            backgroundColor: const Color(0xFF2A2A2A),
                            textColor: Colors.white,
                            height: 48,
                          ),
                        ),
                        Spacing.hMedium,
                        Expanded(
                          child: AppButton(
                            text: 'Upload PDF',
                            onPressed: () async {
                              await context.read<ReportCubit>().uploadPdf();
                            },
                            backgroundColor: const Color(0xFF2A2A2A),
                            textColor: Colors.white,
                            height: 48,
                          ),
                        ),
                      ],
                    ),
                    Spacing.vMedium,
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Send Report',
                            style: AppTextStyles.bodyExtraSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacing.vSmall,
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: AppTextFormField(
                                  labelOnTop: true,
                                  labelText: 'Recipient email',
                                  controller: _recipientController,
                                ),
                              ),
                              Spacing.hMedium,
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 24),
                                  child: AppButton(
                                    text: 'Send Email (SES)',
                                    onPressed: () async {
                                      final to = _recipientController.text
                                          .trim();
                                      if (to.isEmpty) return;
                                      await context
                                          .read<ReportCubit>()
                                          .sendViaCloudFunction(to);
                                    },
                                    backgroundColor: AppColors.buttonPrimary,
                                    textColor: AppColors.buttonText,
                                    height: 48,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacing.vSmall,
                    BlocBuilder<ReportCubit, ReportState>(
                      builder: (context, state) {
                        final isLoading =
                            state.status == ReportStatus.generating ||
                            state.status == ReportStatus.uploading ||
                            state.status == ReportStatus.sending;

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              if (isLoading)
                                const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.buttonPrimary,
                                    ),
                                  ),
                                ),
                              if (isLoading) const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _getStatusMessage(
                                    state.status,
                                    state.errorMessage,
                                  ),
                                  style: TextStyle(
                                    color: state.status == ReportStatus.error
                                        ? Colors.redAccent
                                        : Colors.white70,
                                    fontWeight:
                                        state.status == ReportStatus.sent
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (state.status == ReportStatus.sent)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.buttonPrimary,
                                  size: 20,
                                ),
                              if (state.status == ReportStatus.error)
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
