import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';
import 'package:test_graduation/core/widgets/property_card.dart';
import 'package:test_graduation/features/home/presentation/view/details_view.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/action_button.dart';

class MyPropertyItem extends StatefulWidget {
  const MyPropertyItem({super.key, required this.property});
  final Property property;

  @override
  State<MyPropertyItem> createState() => _MyPropertyItemState();
}

class _MyPropertyItemState extends State<MyPropertyItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PropertyCard(
          property: widget.property,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PropertyDetailsScreen(property: widget.property),
              ),
            );
          },
        ),
        // أزرار التعديل والحذف
        Positioned(
          top: 16,
          left: 16,
          child: Row(
            children: [
              ActionButton(
                icon: Icons.edit,
                color: AppColors.info,
                onTap: () {
                  // تعديل العقار
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('تعديل العقار')));
                },
              ),
              const SizedBox(width: 8),
              ActionButton(
                icon: Icons.delete,
                color: AppColors.error,
                onTap: () {
                  _showDeleteDialog(widget.property);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(Property property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف العقار'),
        content: Text('هل أنت متأكد من حذف ${property.title}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // _myProperties.remove(property);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم حذف العقار')));
            },
            child: Text(
              AppStrings.delete,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
