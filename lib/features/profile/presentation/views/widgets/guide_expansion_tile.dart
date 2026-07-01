import 'package:flutter/material.dart';
import '../../../../../core/utils/colors.dart';

class GuideExpansionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color iconColor;

  const GuideExpansionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ExpansionTile(
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
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          iconColor: AppColors.primary,
          collapsedIconColor: Theme.of(context).textTheme.bodySmall?.color,
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const Divider(height: 1),
            const SizedBox(height: 12),
            Text(
              content,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
