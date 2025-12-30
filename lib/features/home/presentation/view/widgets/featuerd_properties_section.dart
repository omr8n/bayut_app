import 'package:flutter/material.dart';
import 'package:test_graduation/core/data/mock_data.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/home/presentation/view/details_view.dart';
import 'package:test_graduation/features/home/presentation/view/properties_list_view.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/properties_header.dart';

class FeatuerdPropertiesSection extends StatelessWidget {
  const FeatuerdPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredProperties = MockData.featuredProperties;

    // إذا لم تكن هناك عقارات مميزة، لا نعرض القسم
    if (featuredProperties.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        PropertiesHeader(
          title: AppStrings.featuredProperties,
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PropertiesListScreen(
                  title: AppStrings.featuredProperties,
                  properties: featuredProperties,
                ),
              ),
            );
          },
        ),
        
        // قائمة العقارات المميزة (أفقية)
        SizedBox(
          height: 320, // ارتفاع مناسب للبطاقة في الوضع الأفقي
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            reverse: true, // لتبدأ من اليمين (العربية)
            itemCount: featuredProperties.length,
            itemBuilder: (context, index) {
              final property = featuredProperties[index];
              return Container(
                width: 280, // عرض البطاقة الواحدة
                margin: const EdgeInsets.only(left: 12),
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
          ),
        ),
        const SizedBox(height: 24),
      ]),
    );
  }
}
