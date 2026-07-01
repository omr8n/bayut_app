import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

import 'widgets/guide_footer.dart';
import 'widgets/guide_list.dart';
import 'widgets/guide_search_field.dart';
import 'widgets/profile_sliver_app_bar.dart';

class GuideView extends StatefulWidget {
  const GuideView({super.key});

  @override
  State<GuideView> createState() => _GuideViewState();
}

class _GuideViewState extends State<GuideView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<Map<String, dynamic>> _guideItems = [
    {
      'icon': Icons.gavel_rounded,
      'titleKey': LangKeys.guideLicensedTitle,
      'contentKey': LangKeys.guideLicensedContent,
      'color': Colors.blue,
    },
    {
      'icon': Icons.payments_rounded,
      'titleKey': LangKeys.guideInstallmentTitle,
      'contentKey': LangKeys.guideInstallmentContent,
      'color': Colors.green,
    },
    {
      'icon': Icons.wifi_off_rounded,
      'titleKey': LangKeys.guideOfflineTitle,
      'contentKey': LangKeys.guideOfflineContent,
      'color': Colors.orange,
    },
    {
      'icon': Icons.category_rounded,
      'titleKey': LangKeys.guideTypesTitle,
      'contentKey': LangKeys.guideTypesContent,
      'color': Colors.purple,
    },
    {
      'icon': Icons.star_rounded,
      'titleKey': LangKeys.guideFeaturedTitle,
      'contentKey': LangKeys.guideFeaturedContent,
      'color': Colors.amber,
    },
    {
      'icon': Icons.contact_support_rounded,
      'titleKey': LangKeys.guideContactTitle,
      'contentKey': LangKeys.guideContactContent,
      'color': Colors.teal,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final filteredItems = _guideItems.where((item) {
      final title = localizations.translate(item['titleKey']).toLowerCase();
      return title.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          ProfileSliverAppBar(
            title: localizations.translate(LangKeys.guideUsage),
            icon: Icons.help_outline,
            expandedHeight: 180.0,
          ),
          GuideSearchField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          GuideList(items: filteredItems),
          const GuideFooter(),
        ],
      ),
    );
  }
}
