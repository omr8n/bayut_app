import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';

class AdminUsersFilterSection extends StatelessWidget {
  const AdminUsersFilterSection({
    super.key,
    required this.allUsers,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onSearchChanged,
  });

  final List<UserEntity> allUsers;
  final String? selectedFilter;
  final Function(String?) onFilterChanged;
  final Function(String) onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryBlue = isDark
        ? AppColors.darkBackground
        : const Color(0xFF00142B); // Matching the image's blue

    return Container(
      padding: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: TextField(
              onChanged: onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: local.search_user_hint,
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white60),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _UserFilterChip(
                  label: local.all,
                  isSelected: selectedFilter == null,
                  onTap: () => onFilterChanged(null),
                  count: allUsers.length,
                ),
                const SizedBox(width: 8),
                _UserFilterChip(
                  label: local.active,
                  isSelected: selectedFilter == 'active',
                  onTap: () => onFilterChanged('active'),
                  count: allUsers.where((u) => !u.isBanned).length,
                ),
                const SizedBox(width: 8),
                _UserFilterChip(
                  label: local.banned_user,
                  isSelected: selectedFilter == 'blocked',
                  onTap: () => onFilterChanged('blocked'),
                  count: allUsers.where((u) => u.isBanned).length,
                ),
                const SizedBox(width: 8),
                _UserFilterChip(
                  label: local.admins,
                  isSelected: selectedFilter == 'admin',
                  onTap: () => onFilterChanged('admin'),
                  count: allUsers.where((u) => u.role == 'admin').length,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserFilterChip extends StatelessWidget {
  const _UserFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count = 0,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTextColor = isDark ? Colors.black87 : const Color(0xFF00142B);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? selectedTextColor : Colors.white,
              ),
            ),
            if (count >= 0) ...[
              const SizedBox(width: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? const Color(0xFF1E293B) : const Color(0xFF005696))
                      : Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
