import 'package:flutter/material.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';

class UserSearchDelegate extends SearchDelegate<UserEntity?> {
  final List<UserEntity> users;
  final String? searchLabel;

  UserSearchDelegate(this.users, {this.searchLabel});

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
    final filtered = users
        .where(
          (u) =>
              u.name.toLowerCase().contains(query.toLowerCase()) ||
              u.email.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final user = filtered[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
          onTap: () => close(context, user),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
