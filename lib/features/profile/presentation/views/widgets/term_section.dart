import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import '../../../../../core/utils/colors.dart';

class TermSection extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const TermSection({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isEn = AppLocalizations.of(context)?.isEnLocale ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? 0.2
                    : 0.03,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isEn ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: isEn ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                if (!isEn) ...[
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    icon,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                ] else ...[
                  Icon(
                    icon,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(
                thickness: 0.5,
                color: Theme.of(context).dividerColor,
              ),
            ),
            Text(
              content,
              textAlign: isEn ? TextAlign.left : TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                height: 1.7,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
