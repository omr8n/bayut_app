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
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              onChanged: onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: local.search_user_hint,
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.15),
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
                  color: AppColors.success,
                  count: allUsers.where((u) => !u.isBanned).length,
                ),
                const SizedBox(width: 8),
                _UserFilterChip(
                  label: local.banned_user,
                  isSelected: selectedFilter == 'blocked',
                  onTap: () => onFilterChanged('blocked'),
                  color: AppColors.error,
                  count: allUsers.where((u) => u.isBanned).length,
                ),
                const SizedBox(width: 8),
                _UserFilterChip(
                  label: local.admins,
                  isSelected: selectedFilter == 'admin',
                  onTap: () => onFilterChanged('admin'),
                  color: AppColors.info,
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
    this.color,
    this.count = 0,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;
  final int count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : Colors.white,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (color ?? AppColors.primary)
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
