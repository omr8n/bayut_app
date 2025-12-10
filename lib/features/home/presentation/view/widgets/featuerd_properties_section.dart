import 'package:flutter/material.dart';
import 'package:test_graduation/core/data/mock_data.dart';

import 'package:test_graduation/core/utils/strings_ar.dart';

import 'package:test_graduation/features/home/presentation/view/properties_list_view.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/featuerd_properties.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/properties_header.dart';

class FeatuerdPropertiesSection extends StatelessWidget {
  const FeatuerdPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                  properties: MockData.featuredProperties,
                ),
              ),
            );
          },
        ),
        // قائمة العقارات المميزة
        FeaturedProperties(),
      ]),
    );
  }
}




        // SizedBox(
        //   height: 300,
        //   child: ListView.builder(
        //     padding: const EdgeInsets.symmetric(horizontal: 16),
        //     scrollDirection: Axis.horizontal,
        //     itemCount: MockData.featuredProperties.length,
        //     itemBuilder: (context, index) {
        //       final property = MockData.featuredProperties[index];
        //       return Container(
        //         width: 280,
        //         margin: const EdgeInsets.only(right: 12),
        //         child: PropertyCard(
        //           property: property,
        //           onTap: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) =>
        //                     PropertyDetailsScreen(property: property),
        //               ),
        //             );
        //           },
        //           onFavorite: () {
        //             ScaffoldMessenger.of(context).showSnackBar(
        //               const SnackBar(content: Text('تمت الإضافة للمفضلة')),
        //             );
        //           },
        //         ),
        //       );
        //     },
        //   ),
        // ),
 // Header كنص عادي، ليس Sliver
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(
        //         AppStrings.featuredProperties,
        //         style: const TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //           color: AppColors.textPrimary,
        //         ),
        //       ),
        //       GestureDetector(
        //         onTap: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => PropertiesListScreen(
        //                 title: AppStrings.featuredProperties,
        //                 properties: MockData.featuredProperties,
        //               ),
        //             ),
        //           );
        //         },
        //         child: Text(
        //           'عرض الكل',
        //           style: TextStyle(
        //             fontSize: 14,
        //             fontWeight: FontWeight.w600,
        //             color: AppColors.primary,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),