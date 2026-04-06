import 'package:flutter/material.dart';

class BuildCheckBox extends StatelessWidget {
  const BuildCheckBox({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.value,
    required this.onChanged,
  });
  final String title;
  final IconData icon;
  final Color color;
  final bool? value;
  final Function(bool?) onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color,
            fontSize: 14,
          ),
        ),
        secondary: Icon(icon, color: color, size: 20),
        value: value ?? false,
        onChanged: onChanged,
        activeColor: color,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
