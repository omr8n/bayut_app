import 'package:flutter/material.dart';
import 'package:test_graduation/core/data/mock_data.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/features/home/presentation/view/properties_list_view.dart';
import 'package:test_graduation/features/home/presentation/view/widgets/item_type_button.dart';

class ListTypeButtons extends StatelessWidget {
  const ListTypeButtons({super.key});

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
                        properties: MockData.propertiesForSale,
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
                        properties: MockData.propertiesForRent,
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
