import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/features/home/presentation/view/properties_list_view.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/item_type_button.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class ListTypeButtons extends StatelessWidget {
  // 🔥 استقبال البيانات الجاهزة من الـ BlocBuilder
  const ListTypeButtons({
    super.key,
    required this.saleProperties,
    required this.rentProperties,
  });

  final List<PropertyEntity> saleProperties;
  final List<PropertyEntity> rentProperties;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: ItemTypeButton(
                title: AppStrings.forSale,
                icon: Icons.sell_outlined,
                color: AppColors.forSale,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertiesListScreen(
                        title: AppStrings.forSale,
                        properties: saleProperties, // 🔥 تمرير البيانات الحقيقية
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ItemTypeButton(
                title: AppStrings.forRent,
                icon: Icons.key_outlined,
                color: AppColors.forRent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertiesListScreen(
                        title: AppStrings.forRent,
                        properties: rentProperties, // 🔥 تمرير البيانات الحقيقية
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
