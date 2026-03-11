import 'package:flutter/material.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/home/presentation/view/details_view.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class RecentProperties extends StatelessWidget {
  const RecentProperties({super.key, required this.properties});
  final List<PropertyEntity> properties;

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    // 🔥 تحويل الـ Column إلى SliverList لضمان أفضل أداء وتوافق مع CustomScrollView
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final property = properties[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PropertyCard(
                property: property,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertyDetailsScreen(property: property),
                    ),
                  );
                },
              ),
            );
          },
          childCount: properties.length,
        ),
      ),
    );
  }
}
