import 'package:flutter/material.dart';
import 'package:test_graduation/core/data/mock_data.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/home/presentation/view/details_view.dart';

class RecentProperties extends StatelessWidget {
  const RecentProperties({super.key});

  @override
  Widget build(BuildContext context) {
    // تصفية القائمة لعرض العقارات غير المميزة فقط
    final recent = MockData.properties
        .where((p) => !p.isFeatured) // استثناء العقارات المميزة من الظهور هنا
        .take(5)
        .toList();

    if (recent.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(recent.length, (index) {
          final property = recent[index];
          return PropertyCard(
            property: property,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PropertyDetailsScreen(property: property),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
