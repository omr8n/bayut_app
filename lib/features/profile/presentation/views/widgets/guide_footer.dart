import 'package:flutter/material.dart';
import '../../../../../core/utils/colors.dart';

class GuideFooter extends StatelessWidget {
  const GuideFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Text(
              'هل لديك أسئلة أخرى؟',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(height: 8),
            Text(
              'تواصل مع الدعم الفني',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
