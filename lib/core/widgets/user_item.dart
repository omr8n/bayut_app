import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/models/user_model.dart';
import 'package:test_graduation/core/utils/colors.dart';

// عنصر المستخدم في القائمة
class UserItem extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onBlock;
  final VoidCallback? onDelete;
  final bool isBlocked;

  const UserItem({
    super.key,
    required this.user,
    this.onTap,
    this.onBlock,
    this.onDelete,
    this.isBlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isBlocked
                ? AppColors.error.withValues(alpha: 0.1)
                : AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            color: isBlocked ? AppColors.error : AppColors.primary,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: user.userType == UserType.agent
                    ? AppColors.info.withValues(alpha: 0.1)
                    : AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                user.userType.arabicName,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: user.userType == UserType.agent
                      ? AppColors.info
                      : AppColors.success,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              user.email,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 2),
            Text(
              user.phone,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              'انضم: ${DateFormat('yyyy/MM/dd').format(user.createdAt)}',
              style: TextStyle(fontSize: 11, color: AppColors.textLight),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onBlock != null)
              IconButton(
                onPressed: onBlock,
                icon: Icon(
                  isBlocked ? Icons.check_circle : Icons.block,
                  color: isBlocked ? AppColors.success : AppColors.warning,
                  size: 20,
                ),
                tooltip: isBlocked ? 'إلغاء الحظر' : 'حظر',
              ),
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: 20,
                ),
                tooltip: 'حذف',
              ),
          ],
        ),
      ),
    );
  }
}
