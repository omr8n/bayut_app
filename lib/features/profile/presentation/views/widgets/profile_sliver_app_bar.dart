import 'package:flutter/material.dart';
import '../../../../../core/utils/colors.dart';

class ProfileSliverAppBar extends StatelessWidget {
  final String title;
  final IconData icon;
  final double expandedHeight;

  const ProfileSliverAppBar({
    super.key,
    required this.title,
    required this.icon,
    this.expandedHeight = 150.0,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackground : AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).brightness == Brightness.dark ? AppColors.darkGradient : AppColors.primaryGradient,
          ),
          child: Opacity(
            opacity: 0.1,
            child: Icon(icon, size: expandedHeight * 0.8, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
