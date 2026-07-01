import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isLast;
  final Widget? trailing;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.onTap,
    this.isLast = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor, // نقل اللون إلى هنا لحل مشكلة الـ Splash
      borderRadius: isLast 
          ? const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )
          : null,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppColors.textPrimary,
          ),
        ),
        trailing: trailing ??
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
        onTap: onTap,
      ),
    );
  }
}
