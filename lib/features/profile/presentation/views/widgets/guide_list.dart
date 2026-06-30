import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';

import 'guide_expansion_tile.dart';

class GuideList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const GuideList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = items[index];
          return GuideExpansionTile(
            icon: item['icon'],
            title: localizations.translate(item['titleKey']),
            content: localizations.translate(item['contentKey']),
            iconColor: item['color'],
          );
        }, childCount: items.length),
      ),
    );
  }
}
