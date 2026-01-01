import 'package:action_inc_taxi_app/core/widgets/responsive_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_inc_taxi_app/core/widgets/buttons/app_button.dart';
import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:action_inc_taxi_app/core/widgets/form/form_field.dart';
import 'package:action_inc_taxi_app/core/widgets/snackbar/spacing.dart';
import 'package:action_inc_taxi_app/core/theme/app_text_styles.dart';
import 'package:action_inc_taxi_app/core/theme/app_colors.dart';
import 'package:action_inc_taxi_app/cubit/auth/login_cubit.dart';
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
        return 'Sending email...';
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
      body: SafeArea(
        child: Column(
          children: [
            const Navbar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                       ResponsiveText(
                          'Vehicle Inspection Report',
                          style: AppTextStyles.bodyExtraSmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const Spacer(),
                        AppButton(
                          text: '+ Add Row',
                          onPressed: _addEmptyRow,
                          backgroundColor: AppColors.buttonPrimary,
                          textColor: AppColors.buttonText,
                        ),
                      ],
                    ),

                    Spacing.vStandard,
                    if (_plateControllers.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF151515),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: ResponsiveText(
                          'No entries added. Click "+ Add Row" to start adding inspection data.',
                          style: AppTextStyles.bodyExtraSmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      )
                    else
                      ...List.generate(_plateControllers.length, (index) {
                        return _ReportRowCard(
                          index: index + 1,
                          date: _dates[index],
                          onDateChanged: (picked) {
                            setState(() => _dates[index] = picked);
                          },
                          onRemove: () {
                            setState(() {
                              _plateControllers.removeAt(index);
                              _modelControllers.removeAt(index);
                              _driverControllers.removeAt(index);
                              _cleanControllers.removeAt(index);
                              _remarksControllers.removeAt(index);
                              _dates.removeAt(index);
                            });
                          },
                          plateController: _plateControllers[index],
                          modelController: _modelControllers[index],
                          driverController: _driverControllers[index],
                          cleanController: _cleanControllers[index],
                          remarksController: _remarksControllers[index],
                        );
                      }),

                    Spacing.vMedium,
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        AppButton(
                          text: 'Generate PDF',
                          onPressed: () async {
                            final loginState = context.read<LoginCubit>().state;
                            final generatedBy = loginState is LoginSuccess
                                ? loginState.user.name
                                : 'Unknown';
                            _collectRowsAndPushToCubit();
                            await context.read<ReportCubit>().generatePdf(
                              generatedBy: generatedBy,
                              generatedAt: DateTime.now(),
                            );
                          },
                          backgroundColor: AppColors.buttonPrimary,
                          textColor: AppColors.buttonText,
                        ),
                        AppButton(
                          text: 'Preview PDF',
                          onPressed: () async {
                            await context.read<ReportCubit>().previewPdf();
                          },
                          backgroundColor: const Color(0xFF2A2A2A),
                          textColor: Colors.white,
                        ),
                        AppButton(
                          text: 'Upload PDF',
                          onPressed: () async {
                            await context.read<ReportCubit>().uploadPdf();
                          },
                          backgroundColor: const Color(0xFF2A2A2A),
                          textColor: Colors.white,
                        ),
                      ],
                    ),

                    Spacing.vMedium,
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveText(
                            'Send Report',
                            style: AppTextStyles.bodyExtraSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacing.vSmall,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                                child: AppButton(
                                  text: 'Send Email',
                                  onPressed: () async {
                                    final to = _recipientController.text.trim();
                                    if (to.isEmpty) return;
                                    await context
                                        .read<ReportCubit>()
                                        .sendViaCloudFunction(to);
                                  },
                                  backgroundColor: AppColors.buttonPrimary,
                                  textColor: AppColors.buttonText,
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
                            color: const Color(0xFF111111),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white10),
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
                                child: ResponsiveText(
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
          ],
        ),
      ),
    );
  }

}

class _ReportRowCard extends StatelessWidget {
  final int index;
  final DateTime date;
  final void Function(DateTime) onDateChanged;
  final VoidCallback onRemove;
  final TextEditingController plateController;
  final TextEditingController modelController;
  final TextEditingController driverController;
  final TextEditingController cleanController;
  final TextEditingController remarksController;

  const _ReportRowCard({
    required this.index,
    required this.date,
    required this.onDateChanged,
    required this.onRemove,
    required this.plateController,
    required this.modelController,
    required this.driverController,
    required this.cleanController,
    required this.remarksController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ResponsiveText(
                'Entry #$index',
                style: AppTextStyles.bodyExtraSmall.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 20,
                ),
              ),
            ],
          ),
          Spacing.vSmall,
          Row(
            children: [
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    onDateChanged(picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8),
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
                        date.toIso8601String().split('T').first,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Spacing.vSmall,
          AppTextFormField(
            labelOnTop: true,
            labelText: 'Plate Number',
            controller: plateController,
          ),
          Spacing.vSmall,
          AppTextFormField(
            labelOnTop: true,
            labelText: 'Vehicle Model / Type',
            controller: modelController,
          ),
          Spacing.vSmall,
          AppTextFormField(
            labelOnTop: true,
            labelText: 'Driver Name',
            controller: driverController,
          ),
          Spacing.vSmall,
          AppTextFormField(
            labelOnTop: true,
            labelText: 'Cleanliness',
            controller: cleanController,
          ),
          Spacing.vSmall,
          AppTextFormField(
            labelOnTop: true,
            labelText: 'Remarks',
            controller: remarksController,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
