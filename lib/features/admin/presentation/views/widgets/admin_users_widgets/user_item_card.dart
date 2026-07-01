import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'user_details_bottom_sheet.dart';

class UserItemCard extends StatelessWidget {
  final UserEntity user;
  final AdminCubit adminCubit;

  const UserItemCard({super.key, required this.user, required this.adminCubit});

  @override
  Widget build(BuildContext context) {
    final bool isBanned = user.isBanned; // Use isBanned instead of status
    final bool isFrozen = user.status == 'frozen';
    final bool isAdmin = user.role == 'admin';
    final local = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: isDark ? AppColors.darkCard : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.05),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showUserDetails(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 1. Avatar (Starts on Left in LTR, Right in RTL)
              _buildAvatar(isAdmin, isBanned, isFrozen, isDark),
              
              const SizedBox(width: 12),

              // 2. Info and Stats (Flexible area)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isAdmin) const SizedBox(width: 8),
                        if (isAdmin) _buildAdminBadge(local, isDark),
                      ],
                    ),
                    Text(
                      user.email,
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatsRow(isDark),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // 3. Status Pill (Ends on Right in LTR, Left in RTL)
              _buildStatusPill(isBanned, isFrozen, local, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminBadge(AppLocalizations local, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        "Admin",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildStatusPill(bool isBanned, bool isFrozen, AppLocalizations local, bool isDark) {
    Color color = Colors.green;
    String label = local.active;
    if (isBanned) {
      color = Colors.red;
      label = local.banned_user;
    } else if (isFrozen) {
      color = Colors.orange;
      label = local.frozen_label;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    return Row(
      children: [
        _miniStat(Icons.home_work_outlined, "${user.propertiesCount}", isDark),
        const SizedBox(width: 12),
        _miniStat(Icons.report_gmailerrorred_outlined, "${user.reportsCount}", isDark),
        const SizedBox(width: 12),
        _miniStat(Icons.access_time, "0", isDark),
      ],
    );
  }

  Widget _miniStat(IconData icon, String value, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: isDark ? AppColors.textSecondaryDark : Colors.grey[400],
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textSecondaryDark : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(bool isAdmin, bool isBanned, bool isFrozen, bool isDark) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isBanned ? Colors.red.withValues(alpha: 0.5) : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: isDark ? AppColors.darkSurface : Colors.grey[100],
            backgroundImage: user.profilePic != null
                ? NetworkImage(user.profilePic!)
                : null,
            child: user.profilePic == null
                ? Icon(
                    Icons.person,
                    color: isAdmin ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : Colors.grey),
                    size: 30,
                  )
                : null,
          ),
        ),
        if (isBanned)
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.block, size: 14, color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget _buildMiniStats(bool isBanned, bool isFrozen, AppLocalizations local, bool isDark) {
    return Row(
      children: [
        _statChip(
          Icons.home_work_outlined,
          "${user.propertiesCount}",
          Colors.blue,
          isDark,
        ),
        const SizedBox(width: 8),
        _statChip(
          Icons.report_gmailerrorred_outlined,
          "${user.reportsCount}",
          Colors.orange,
          isDark,
        ),
        const SizedBox(width: 8),
        if (isBanned)
          _statusLabel(local.banned_user, Colors.red)
        else if (isFrozen)
          _statusLabel(local.frozen_label, Colors.orange)
        else
          _statusLabel(local.active, Colors.green),
      ],
    );
  }

  Widget _statChip(IconData icon, String count, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
    );
  }

  void _showUserDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          UserDetailsBottomSheet(user: user, adminCubit: adminCubit),
    );
  }
}
