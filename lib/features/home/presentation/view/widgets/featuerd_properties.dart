import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/utils.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class FeaturedProperties extends StatelessWidget {
  const FeaturedProperties({super.key, required this.properties});
  final List<PropertyEntity> properties;

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) return const SizedBox.shrink();

    return CarouselSlider(
      options: CarouselOptions(
        height: Utils(context).getScreenSize.height * 0.45,
        viewportFraction: .85,
        enlargeCenterPage: true,

        autoPlay: true,

        //autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(seconds: 5),
      ),
      items: properties.map((property) {
        return PropertyCard(
          // isCompact: true, // 🔥 تصميم مدمج للعقارات المميزة
          property: property,
          onTap: () {
            GoRouter.of(
              context,
            ).push(AppRoutes.propertyDetailsScreen, extra: property);
          },
        );
      }).toList(),
    );
  }
}
