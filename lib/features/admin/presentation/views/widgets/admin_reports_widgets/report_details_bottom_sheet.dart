import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/reports/domain/entities/report_entity.dart';
import 'report_detail_card.dart';
import 'admin_action_buttons.dart';
import 'admin_power_section.dart';

class ReportDetailsBottomSheet extends StatefulWidget {
  const ReportDetailsBottomSheet({
    super.key,
    required this.report,
    required this.adminCubit,
  });

  final ReportEntity report;
  final AdminCubit adminCubit;

  @override
  State<ReportDetailsBottomSheet> createState() =>
      _ReportDetailsBottomSheetState();
}

class _ReportDetailsBottomSheetState extends State<ReportDetailsBottomSheet> {
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    noteController = TextEditingController(text: widget.report.adminNote);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: widget.adminCubit,
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              _buildModalHandle(),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildModalHeader(context, local),
                    const SizedBox(height: 24),
                    _buildStatusBadge(widget.report.status),
                    const SizedBox(height: 24),
                    _buildSectionTitle(local.property_and_reporter_info),
                    ReportDetailCard(
                      children: [
                        ReportDetailRow(
                          icon: Icons.home_work_rounded,
                          label: local.property_title,
                          value: widget.report.propertyTitle,
                          color: AppColors.primary,
                          trailing: TextButton(
                            onPressed: () => context.pushNamed(
                              AppRoutes.propertyDetailsById,
                              pathParameters: {'id': widget.report.propertyId},
                            ),
                            child: Text(
                              local.preview,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ReportDetailRow(
                          icon: Icons.person_rounded,
                          label: local.reporter,
                          value: widget.report.reporterName,
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.alternate_email,
                              color: AppColors.info,
                              size: 20,
                            ),
                            onPressed: () => _launchEmail(
                              widget.report.reporterEmail,
                              local.regarding_your_report,
                            ),
                          ),
                        ),
                        ReportDetailRow(
                          icon: Icons.person_pin_circle_rounded,
                          label: local.reported_user,
                          value: widget.report.reportedUserName,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle(local.report_details),
                    ReportDetailCard(
                      children: [
                        ReportDetailRow(
                          icon: Icons.report_problem_rounded,
                          label: local.reason_label,
                          value: widget.report.reason.localizedName(context),
                          color: AppColors.error,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            local.violation_description,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Text(
                            widget.report.description,
                            style: const TextStyle(fontSize: 14, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle(local.admin_actions_and_notes),
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: local.write_admin_notes_hint,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AdminActionButtons(
                      report: widget.report,
                      onUpdateStatus: (status) =>
                          _updateStatus(context, status),
                    ),
                    const SizedBox(height: 32),
                    AdminPowerSection(
                      onDeleteProperty: () => _showResolveOptions(context),
                      onBlockUser: () => _showBlockUserDialog(context),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildModalHeader(BuildContext context, AppLocalizations local) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          local.full_report_details,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[800],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ReportStatus status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            status.localizedName(context),
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return AppColors.warning;
      case ReportStatus.underReview:
        return AppColors.info;
      case ReportStatus.resolved:
        return AppColors.success;
      case ReportStatus.rejected:
        return AppColors.error;
    }
  }

  void _updateStatus(BuildContext context, ReportStatus status) {
    Navigator.pop(context);
    widget.adminCubit.updateReportStatus(
      widget.report.id,
      status.name,
      adminNote: noteController.text,
      reporterId: widget.report.reporterId,
    );
  }

  void _showBlockUserDialog(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: widget.adminCubit,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 8),
              Text(local.confirm_final_block),
            ],
          ),
          content: Text(
            local.block_user_confirm_msg.replaceFirst(
              '{name}',
              widget.report.reportedUserName,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(local.go_back),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
                widget.adminCubit.toggleUserBlock(
                  widget.report.reportedUserId,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                local.confirm_block,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResolveOptions(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: widget.adminCubit,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(local.make_resolution_decision),
          content: Text(local.resolution_decision_msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _updateStatus(context, ReportStatus.resolved);
              },
              child: Text(local.close_report_only),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
                widget.adminCubit.deleteProperty(
                  widget.report.propertyId,
                  widget.report.reportedUserId,
                );
                widget.adminCubit.updateReportStatus(
                  widget.report.id,
                  'resolved',
                  adminNote: noteController.text.isEmpty
                      ? local.property_deleted_msg
                      : noteController.text,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                local.delete_property_now,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail(String email, String subject) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${Uri.encodeComponent(subject)}',
    );
    if (await canLaunchUrl(params)) await launchUrl(params);
  }
}
