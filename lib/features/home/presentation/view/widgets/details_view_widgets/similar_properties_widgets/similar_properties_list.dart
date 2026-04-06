import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/details_view_widgets/similar_property_card.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class SimilarPropertiesList extends StatelessWidget {
  final List<PropertyEntity> similarProperties;

  const SimilarPropertiesList({super.key, required this.similarProperties});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: similarProperties.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final item = similarProperties[index];
          return Padding(
            padding: EdgeInsetsDirectional.only(end: 12.w),
            child: SimilarPropertyCard(
              property: item,
              onTap: () {
                context.push(AppRoutes.propertyDetailsScreen, extra: {
                  'property': item,
                  'initialIndex': 0,
                });
              },
            ),
          );
        },
      ),
    );
  }
}
