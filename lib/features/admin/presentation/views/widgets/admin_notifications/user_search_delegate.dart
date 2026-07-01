import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/features/admin/domain/repos/admin_repo.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';

class UserSearchDelegate extends SearchDelegate<UserEntity?> {
  final AdminRepo adminRepo;
  final String? searchLabel;

  UserSearchDelegate(this.adminRepo, {this.searchLabel});

  @override
  String? get searchFieldLabel => searchLabel;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    if (query.isEmpty) {
      return Center(child: Text(local.search_user_hint));
    }

    return FutureBuilder(
      future: adminRepo.searchUsers(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('${local.error_label}: ${snapshot.error}'));
        }

        final result = snapshot.data;
        if (result == null) return const SizedBox.shrink();

        return result.fold((failure) => Center(child: Text(failure.message)), (
          users,
        ) {
          if (users.isEmpty) {
            return Center(child: Text(local.no_matching_users));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.profilePic != null
                      ? NetworkImage(user.profilePic!)
                      : null,
                  child: user.profilePic == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: user.status == 'active'
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    user.status,
                    style: TextStyle(
                      fontSize: 10,
                      color: user.status == 'active'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () => close(context, user),
              );
            },
          );
        });
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    if (query.isEmpty) {
      return Center(child: Text(local.search_user_hint));
    }
    return buildResults(context);
  }
}
