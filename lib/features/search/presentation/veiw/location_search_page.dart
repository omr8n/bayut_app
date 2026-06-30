import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/widgets/search_field_widget.dart';
import 'widgets/location_search_page_body.dart';

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
              onPressed: () => context.pop(),
            ),
            // 🔥 Expanded هو الأب المباشر للـ Row، والـ Hero بداخله
            Expanded(
              child: Hero(
                tag: "Search",
                child: Material(
                  color: Colors.transparent,
                  child: SearchFieldWidget(
                    controller: _searchController,
                    onChanged: (val) {
                      // هنا يمكن إضافة فلترة لحظية للمواقع إذا أردت
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // 🔥 استدعاء الـ Body المستقل (Clean MVVM)
      body: LocationSearchPageBody(searchController: _searchController),
    );
  }
}
