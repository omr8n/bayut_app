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
    final bool isBanned = user.status == 'banned';
    final bool isFrozen = user.status == 'frozen';
    final bool isAdmin = user.role == 'admin';
    final local = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isBanned
              ? Colors.red.withValues(alpha: .3)
              : isFrozen
              ? Colors.orange.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.1),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showUserDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildAvatar(isAdmin, isBanned, isFrozen),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (user.isVerified)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.verified,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ),
                        if (isAdmin)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.shield,
                              size: 14,
                              color: AppColors.info,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      user.email,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    _buildMiniStats(isBanned, isFrozen, local),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isAdmin, bool isBanned, bool isFrozen) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: isAdmin
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.grey[100],
          backgroundImage: user.profilePic != null
              ? NetworkImage(user.profilePic!)
              : null,
          child: user.profilePic == null
              ? Icon(
                  Icons.person,
                  color: isAdmin ? AppColors.primary : Colors.grey,
                )
              : null,
        ),
        if (isBanned || isFrozen)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isBanned ? Icons.block : Icons.ac_unit,
                size: 14,
                color: isBanned ? Colors.red : Colors.orange,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMiniStats(bool isBanned, bool isFrozen, AppLocalizations local) {
    return Row(
      children: [
        _statChip(
          Icons.home_work_outlined,
          "${user.propertiesCount}",
          Colors.blue,
        ),
        const SizedBox(width: 8),
        _statChip(
          Icons.report_gmailerrorred_outlined,
          "${user.reportsCount}",
          Colors.orange,
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

  Widget _statChip(IconData icon, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
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
