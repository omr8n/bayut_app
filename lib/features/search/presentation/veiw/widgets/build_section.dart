import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/filter_section_title.dart';

class BuildSection extends StatelessWidget {
  const BuildSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });
  final String title;
  final IconData icon;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        Row(
          children: [
            Icon(icon, size: 22, color: isDark ? AppColors.primary : AppColors.primary),
            const SizedBox(width: 10),
            FilterSectionTitle(title: title),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}
