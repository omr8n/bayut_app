import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';

class UserDetailsBottomSheet extends StatefulWidget {
  const UserDetailsBottomSheet({
    super.key,
    required this.user,
    required this.adminCubit,
  });

  final UserEntity user;
  final AdminCubit adminCubit;

  @override
  State<UserDetailsBottomSheet> createState() => _UserDetailsBottomSheetState();
}

class _UserDetailsBottomSheetState extends State<UserDetailsBottomSheet> {
  late TextEditingController notesController;
  bool isEmailVisible = false;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController(text: widget.user.adminNotes ?? '');
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: widget.adminCubit,
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              _buildHeader(local),
              const SizedBox(height: 24),
              _buildInfoCard(local),
              const SizedBox(height: 24),
              Text(
                local.admin_notes,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildNotesField(local),
              const SizedBox(height: 24),
              Text(
                local.account_actions,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildActionButtons(context, local),
              const SizedBox(height: 32),
              _buildDangerZone(context, local),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations local) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          backgroundImage: widget.user.profilePic != null
              ? NetworkImage(widget.user.profilePic!)
              : null,
          child: widget.user.profilePic == null
              ? const Icon(Icons.person, size: 35, color: AppColors.primary)
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.user.role == 'admin' ? local.admin_role : local.user_role,
                style: TextStyle(
                  color: widget.user.role == 'admin'
                      ? AppColors.info
                      : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(AppLocalizations local) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.email, widget.user.email),
          const Divider(),
          _buildInfoRow(
            Icons.phone,
            widget.user.phoneNumber ?? local.no_phone_number,
          ),
          const Divider(),
          _buildInfoRow(
            Icons.calendar_today,
            local.member_since.replaceFirst('{date}', _formatDate(widget.user.createdAt, local)),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp, AppLocalizations local) {
    if (timestamp == null) return local.retry; // Or some fallback
    if (timestamp is DateTime)
      return "${timestamp.year}-${timestamp.month}-${timestamp.day}";
    return local.loading;
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildNotesField(AppLocalizations local) {
    return Column(
      children: [
        TextField(
          controller: notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: local.write_notes_hint,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[100]!),
            ),
          ),
        ),
        Align(
          alignment: local.isEnLocale ? Alignment.centerRight : Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => widget.adminCubit.updateAdminNotes(
              widget.user.uId,
              notesController.text,
            ),
            icon: const Icon(Icons.save, size: 16),
            label: Text(local.save_note),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, AppLocalizations local) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _launchEmail(widget.user.email),
                icon: const Icon(Icons.mail_outline, color: Colors.white),
                label: Text(
                  local.send_email,
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.info,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => widget.adminCubit.toggleUserBlock(
                  widget.user.uId,
                  !widget.user.isBanned,
                ),
                icon: Icon(
                  widget.user.isBanned ? Icons.lock_open : Icons.block,
                  color: Colors.white,
                ),
                label: Text(
                  widget.user.isBanned ? local.unblock_user : local.block_account,
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.user.isBanned
                      ? AppColors.success
                      : AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              context.pushNamed(
                AppRoutes.adminNotifications,
                extra: {'uId': widget.user.uId, 'name': widget.user.name},
              );
            },
            icon: const Icon(Icons.send_rounded, color: Colors.white),
            label: Text(
              local.send_notification_to_user,
              style: const TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDangerZone(BuildContext context, AppLocalizations local) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Column(
        children: [
          Text(
            local.danger_zone,
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _confirmDelete(context, local),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
              ),
              child: Text(
                local.delete_user_forever,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppLocalizations local) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(local.permanent_delete),
        content: Text(local.delete_user_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(local.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              widget.adminCubit.deleteUser(widget.user.uId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(local.confirm_delete),
          ),
        ],
      ),
    );
  }

  void _launchEmail(String email) async {
    final Uri params = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(params)) await launchUrl(params);
  }
}
