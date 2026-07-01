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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().fetchUsers(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<AdminCubit>().fetchUsers();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryBlue = isDark
        ? AppColors.darkBackground
        : const Color(0xFF00142B);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        title: Text(
          AppLocalizations.of(context)!.manage_users,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<AdminCubit, AdminState>(
        listener: _adminListener,
        builder: (context, state) {
          final isLoading = state is AdminLoading;
          List<UserEntity> allUsers = [];
          if (state is AdminUsersSuccess) {
            allUsers = state.users;
          }

          final filteredUsers = _getFilteredUsers(allUsers);

          return Column(
            children: [
              if (isLoading)
                const LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: AppColors.primary,
                  minHeight: 3,
                ),
              AdminUsersFilterSection(
                allUsers: allUsers,
                selectedFilter: filterType,
                onFilterChanged: (val) => setState(() => filterType = val),
                onSearchChanged: (val) => setState(() => searchQuery = val),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await context.read<AdminCubit>().fetchUsers(
                      isRefresh: true,
                    );
                  },
                  color: AppColors.primary,
                  child: filteredUsers.isEmpty
                      ? (isLoading
                            ? const SizedBox.shrink()
                            : _buildEmptyState(context))
                      : ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount:
                              state is AdminUsersSuccess && !state.hasReachedMax
                              ? filteredUsers.length + 1
                              : filteredUsers.length,
                          itemBuilder: (context, index) {
                            if (index >= filteredUsers.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final user = filteredUsers[index];
                            return UserItemCard(
                              user: user,
                              adminCubit: context
                                  .read<AdminCubit>(), // Pass cubit here
                            );
                          },
                        ),
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
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Center(
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
        ),
      ],
    );
  }
}
