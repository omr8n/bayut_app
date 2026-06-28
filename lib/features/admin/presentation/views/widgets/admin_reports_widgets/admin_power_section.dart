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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.red[50]!, Colors.orange[50]!]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.gavel_rounded, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                local.admin_strict_actions,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
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
                  icon: Icons.delete_forever,
                  color: Colors.red,
                  onPressed: onDeleteProperty,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PowerButton(
                  label: local.block_user,
                  icon: Icons.block,
                  color: Colors.black,
                  onPressed: onBlockUser,
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
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
      ),
    );
  }
}
