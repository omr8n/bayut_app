import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_state.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'widgets/admin_users_widgets/admin_users_filter_section.dart';
import 'widgets/admin_users_widgets/user_item_card.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  String searchQuery = '';
  String? filterType; // null (all), 'active', 'blocked', 'admin'

  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().fetchUsers();
  }

  List<UserEntity> _getFilteredUsers(List<UserEntity> allUsers) {
    return allUsers.where((user) {
      final bool matchesSearch =
          user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(searchQuery.toLowerCase());

      bool matchesFilter = true;
      if (filterType == 'active') matchesFilter = !user.isBanned;
      if (filterType == 'blocked') matchesFilter = user.isBanned;
      if (filterType == 'admin') matchesFilter = user.role == 'admin';

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          AppLocalizations.of(context)!.manage_users,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<AdminCubit, AdminState>(
        listener: _adminListener,
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          List<UserEntity> allUsers = [];
          if (state is AdminUsersSuccess) {
            allUsers = state.users;
          }

          final filteredUsers = _getFilteredUsers(allUsers);

          return Column(
            children: [
              AdminUsersFilterSection(
                allUsers: allUsers,
                selectedFilter: filterType,
                onFilterChanged: (val) => setState(() => filterType = val),
                onSearchChanged: (val) => setState(() => searchQuery = val),
              ),
              Expanded(
                child: filteredUsers.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          return UserItemCard(
                            user: user,
                            adminCubit: context
                                .read<AdminCubit>(), // Pass cubit here
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _adminListener(BuildContext context, AdminState state) {
    if (state is AdminActionSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (state is AdminFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errMessage),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.no_matching_users,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
