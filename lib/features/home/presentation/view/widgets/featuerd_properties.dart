import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/home/presentation/view/details_view.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class FeaturedProperties extends StatelessWidget {
  const FeaturedProperties({super.key, required this.properties});
  final List<PropertyEntity> properties;

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) return const SizedBox.shrink();

    return CarouselSlider(
      options: CarouselOptions(
        height: 320, // 🔥 زيادة الارتفاع لضمان عدم حدوث Overflow في الكروت
        enlargeCenterPage: true,
        disableCenter: true,
        viewportFraction: .8,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
      ),
      items: properties.map((property) {
        return Builder(
          builder: (BuildContext context) {
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
          },
        );
      }).toList(),
    );
  }
}
