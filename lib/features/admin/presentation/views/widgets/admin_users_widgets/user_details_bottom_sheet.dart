import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/services/communication_service.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/core/widgets/communication_dialogs.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_state.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: widget.adminCubit,
      child: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          // 🔥 استخراج أحدث بيانات للمستخدم من الـ State لضمان عمل الـ Optimistic UI داخل الـ BottomSheet
          UserEntity currentUser = widget.user;
          if (state is AdminUsersSuccess) {
            final found = state.users.where((u) => u.uId == widget.user.uId);
            if (found.isNotEmpty) currentUser = found.first;
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    children: [
                      _buildHeader(local, isDark, currentUser),
                      const SizedBox(height: 24),
                      _buildInfoSection(local, isDark, currentUser),
                      const SizedBox(height: 24),
                      _buildNotesSection(local, isDark, currentUser),
                      const SizedBox(height: 24),
                      _buildCommunicationSection(local, isDark, currentUser),
                      const SizedBox(height: 12),
                      _buildMainActions(context, local, isDark, currentUser),
                      const SizedBox(height: 24),
                      _buildDangerZone(context, local, isDark, currentUser),
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

  Widget _buildHeader(AppLocalizations local, bool isDark, UserEntity user) {
    return Row(
      children: [
        Hero(
          tag: 'user_avatar_${user.uId}',
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: isDark
                  ? AppColors.darkSurface
                  : Colors.grey[100],
              backgroundImage: user.profilePic != null
                  ? NetworkImage(user.profilePic!)
                  : null,
              child: user.profilePic == null
                  ? Icon(
                      Icons.person,
                      size: 40,
                      color: isDark ? Colors.white38 : Colors.grey[400],
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              _buildRoleBadge(local, isDark, user),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleBadge(AppLocalizations local, bool isDark, UserEntity user) {
    final isAdmin = user.role == 'admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAdmin
            ? AppColors.primary.withValues(alpha: 0.1)
            : (isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey[100]),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isAdmin ? local.admin_role : local.user_role,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isAdmin
              ? AppColors.primary
              : (isDark ? Colors.white60 : Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    AppLocalizations local,
    bool isDark,
    UserEntity user,
  ) {
    return Column(
      children: [
        _infoTile(Icons.email_outlined, local.email, user.email, isDark),
        const SizedBox(height: 12),
        _infoTile(
          Icons.phone_outlined,
          local.phone,
          user.phoneNumber ?? local.no_phone_number,
          isDark,
        ),
        const SizedBox(height: 12),
        _infoTile(
          Icons.calendar_month_outlined,
          local.member_since_label,
          _formatDate(user.createdAt, local),
          isDark,
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(
    AppLocalizations local,
    bool isDark,
    UserEntity user,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            local.admin_notes,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: notesController,
          maxLines: 3,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: local.write_notes_hint,
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
          alignment: local.isEnLocale
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => widget.adminCubit.updateAdminNotes(
              user.uId,
              notesController.text,
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

  Widget _buildCommunicationSection(
    AppLocalizations local,
    bool isDark,
    UserEntity user,
  ) {
    return Row(
      children: [
        Expanded(
          child: _commButton(
            local.whatsapp,
            Icons.chat_bubble_outline,
            const Color(0xFF25D366),
            () => _handleWhatsApp(user),
            isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _commButton(
            local.email,
            Icons.email_outlined,
            AppColors.info,
            () => _handleEmail(user),
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _commButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isDark,
  ) {
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
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainActions(
    BuildContext context,
    AppLocalizations local,
    bool isDark,
    UserEntity user,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              context.pushNamed(
                AppRoutes.adminNotifications,
                extra: {
                  'uId': user.uId,
                  'name': user.name,
                  'email': user.email,
                },
              );
            },
            icon: const Icon(
              Icons.notifications_active_outlined,
              color: Colors.white,
            ),
            label: Text(
              local.send_notification_to_user,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDangerZone(
    BuildContext context,
    AppLocalizations local,
    bool isDark,
    UserEntity user,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.red.withValues(alpha: 0.05) : Colors.red[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.gpp_maybe_outlined, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                local.danger_zone,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _dangerButton(
                  user.isBanned ? local.unblock_user : local.block_account,
                  user.isBanned
                      ? Icons.lock_open_outlined
                      : Icons.block_flipped,
                  user.isBanned ? AppColors.success : Colors.orange,
                  () {
                    if (user.isBanned) {
                      // Unblock action
                      widget.adminCubit.toggleUserBlock(user.uId, false);
                    } else {
                      // Block action with confirmation
                      _confirmBlock(context, local, user);
                    }
                  },
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _dangerButton(
                  local.delete_user_forever,
                  Icons.delete_forever_outlined,
                  Colors.red,
                  () => _confirmDelete(context, local, user),
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dangerButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isDark,
  ) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withValues(alpha: 0.3)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: color.withValues(alpha: 0.05),
      ),
    );
  }

  void _handleWhatsApp(UserEntity user) async {
    final phone = user.phoneNumber;
    if (phone == null || phone.isEmpty || phone == "0") {
      CommunicationDialogs.showWhatsAppFallback(
        context,
        onCallPressed: () =>
            getIt<CommunicationService>().makeCall(phone ?? ''),
      );
      return;
    }

    final success = await getIt<CommunicationService>().sendWhatsApp(
      phone,
      message: "Hello ${user.name}, from Bayut Admin.",
    );

    if (!success && mounted) {
      CommunicationDialogs.showWhatsAppFallback(
        context,
        onCallPressed: () => getIt<CommunicationService>().makeCall(phone),
      );
    }
  }

  void _handleEmail(UserEntity user) async {
    await getIt<CommunicationService>().sendEmail(
      user.email,
      subject: "Important update regarding your account",
      body: "Hello ${user.name},",
    );
  }

  void _confirmDelete(
    BuildContext context,
    AppLocalizations local,
    UserEntity user,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(local.permanent_delete),
        content: Text(local.delete_user_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(local.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close bottom sheet

              // Perform deletion - UI will be updated automatically via Cubit state
              await widget.adminCubit.deleteUser(user.uId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              local.confirm_delete,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmBlock(
    BuildContext context,
    AppLocalizations local,
    UserEntity user,
  ) {
    final bool isCurrentlyBanned = user.isBanned;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isCurrentlyBanned
                  ? Icons.lock_open_rounded
                  : Icons.warning_amber_rounded,
              color: isCurrentlyBanned ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 10),
            Text(isCurrentlyBanned ? local.unblock_user : local.block_account),
          ],
        ),
        content: Text(
          isCurrentlyBanned
              ? "هل أنت متأكد من إلغاء حظر حساب ${user.name}؟"
              : local.block_user_confirm_msg.replaceFirst('{name}', user.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(local.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.adminCubit.toggleUserBlock(user.uId, !isCurrentlyBanned);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCurrentlyBanned ? Colors.green : Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isCurrentlyBanned ? local.unblock_user : local.confirm_block,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp, AppLocalizations local) {
    if (timestamp == null) return "-";
    try {
      if (timestamp is DateTime) {
        return DateFormat.yMMMMd(
          local.isEnLocale ? 'en' : 'ar',
        ).format(timestamp);
      }
      // If it's a Timestamp from Firebase
      if (timestamp.runtimeType.toString() == 'Timestamp') {
        return DateFormat.yMMMMd(
          local.isEnLocale ? 'en' : 'ar',
        ).format(timestamp.toDate());
      }
    } catch (e) {
      debugPrint("Error formatting date: $e");
    }
    return "-";
  }
}
