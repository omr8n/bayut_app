import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/services/communication_service.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_state.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: widget.adminCubit,
      child: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                _buildModalHandle(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                    children: [
                      _buildHeader(local, isDark),
                      const SizedBox(height: 24),
                      _buildInfoSection(local, isDark),
                      const SizedBox(height: 24),
                      _buildDetailsSection(local, isDark),
                      const SizedBox(height: 24),
                      _buildNotesSection(local, isDark),
                      const SizedBox(height: 24),
                      _buildCommunicationSection(local, isDark),
                      const SizedBox(height: 12),
                      AdminActionButtons(
                        report: widget.report,
                        onUpdateStatus: (status) => _updateStatus(context, status),
                      ),
                      const SizedBox(height: 24),
                      AdminPowerSection(
                        onDeleteProperty: () => _showResolveOptions(context),
                        onBlockUser: () => _showBlockUserDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildModalHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations local, bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            _buildStatusBadge(widget.report.status),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.error.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: isDark ? AppColors.darkSurface : Colors.grey[100],
            child: Icon(
              Icons.report_gmailerrorred_rounded,
              size: 40,
              color: isDark ? Colors.redAccent : Colors.red,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          local.full_report_details,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(AppLocalizations local, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(local.property_and_reporter_info, isDark),
        const SizedBox(height: 12),
        AdminInfoTile(
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
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        AdminInfoTile(
          icon: Icons.person_rounded,
          label: local.reporter,
          value: widget.report.reporterName,
          color: AppColors.info,
          trailing: const Icon(Icons.alternate_email_rounded, size: 16, color: Colors.grey),
        ),
        AdminInfoTile(
          icon: Icons.person_pin_circle_rounded,
          label: local.reported_user,
          value: widget.report.reportedUserName,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildDetailsSection(AppLocalizations local, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(local.report_details, isDark),
        const SizedBox(height: 12),
        AdminInfoTile(
          icon: Icons.report_problem_rounded,
          label: local.reason_label,
          value: widget.report.reason.localizedName(context),
          color: AppColors.error,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                local.violation_description,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.textSecondaryDark : Colors.grey[500],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.report.description,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(AppLocalizations local, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(local.admin_actions_and_notes, isDark),
        const SizedBox(height: 12),
        TextField(
          controller: noteController,
          maxLines: 3,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: local.write_admin_notes_hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.white24 : Colors.grey[400],
            ),
            filled: true,
            fillColor: isDark ? AppColors.darkInput : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton.icon(
            onPressed: () => widget.adminCubit.updateReportStatus(
              widget.report.id,
              widget.report.status.name,
              adminNote: noteController.text,
            ),
            icon: const Icon(Icons.check_circle_outline, size: 18),
            label: Text(
              local.save_note,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommunicationSection(AppLocalizations local, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _commButton(
            local.whatsapp,
            Icons.chat_bubble_outline_rounded,
            const Color(0xFF25D366),
            () => _handleWhatsApp(),
            isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _commButton(
            local.email,
            Icons.email_outlined,
            AppColors.info,
            () => _handleEmail(),
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _commButton(String label, IconData icon, Color color, VoidCallback onTap, bool isDark) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.15 : 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ReportStatus status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline_rounded, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            status.localizedName(context),
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending: return AppColors.warning;
      case ReportStatus.underReview: return AppColors.info;
      case ReportStatus.resolved: return AppColors.success;
      case ReportStatus.rejected: return AppColors.error;
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

  void _handleWhatsApp() async {
    final success = await getIt<CommunicationService>().sendWhatsApp(
      widget.report.reporterEmail, // Replace with phone if available in entity
      message: "Regarding your report on ${widget.report.propertyTitle}",
    );
  }

  void _handleEmail() async {
    await getIt<CommunicationService>().sendEmail(
      widget.report.reporterEmail,
      subject: "Update on your report",
      body: "Hello ${widget.report.reporterName},",
    );
  }

  void _showBlockUserDialog(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: widget.adminCubit,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 8),
              Text(local.confirm_final_block),
            ],
          ),
          content: Text(
            local.block_user_confirm_msg.replaceFirst('{name}', widget.report.reportedUserName),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(local.go_back)),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
                widget.adminCubit.toggleUserBlock(widget.report.reportedUserId, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(local.confirm_block, style: const TextStyle(color: Colors.white)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(local.delete_property_now, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
