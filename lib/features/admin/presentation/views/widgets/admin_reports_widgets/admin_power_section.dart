import 'package:flutter/material.dart';

import 'package:test_graduation/core/language/app_localizations.dart';

class AdminPowerSection extends StatelessWidget {
  const AdminPowerSection({
    super.key,
    required this.onDeleteProperty,
    required this.onBlockUser,
  });

  final VoidCallback onDeleteProperty;
  final VoidCallback onBlockUser;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.red.withValues(alpha: 0.05) : Colors.red[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.red.withValues(alpha: 0.1)
              : Colors.red.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.gavel_rounded,
                color: isDark ? Colors.redAccent : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                local.admin_strict_actions,
                style: TextStyle(
                  color: isDark ? Colors.redAccent : Colors.red,
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
                child: _PowerButton(
                  label: local.delete_property,
                  icon: Icons.delete_forever_rounded,
                  color: isDark ? Colors.redAccent : Colors.red,
                  onPressed: onDeleteProperty,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PowerButton(
                  label: local.block_user,
                  icon: Icons.person_off_rounded,
                  color: isDark ? Colors.white70 : Colors.black87,
                  onPressed: onBlockUser,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PowerButton extends StatelessWidget {
  const _PowerButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.isDark,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: FittedBox(
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withValues(alpha: 0.3)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: isDark ? color.withValues(alpha: 0.1) : Colors.white,
      ),
    );
  }
}
