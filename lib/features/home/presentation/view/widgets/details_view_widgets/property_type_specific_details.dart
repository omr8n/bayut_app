import 'package:flutter/material.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class PropertyTypeSpecificDetails extends StatelessWidget {
  final PropertyEntity property;
  const PropertyTypeSpecificDetails({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final List<Map<String, String>> specs = [];
    if (property.buildingAge != null) {
      specs.add({
        localizations.translate(LangKeys.buildingAge):
        '${property.buildingAge} ${localizations.translate(LangKeys.year)}'
      });
    }
    if (property.finishType != null) {
      specs.add({localizations.translate(LangKeys.finishType): localizations.translate(property.finishType!)});
    }

    switch (property.type) {
      case PropertyType.housesAndApartments:
      case PropertyType.villas:
      case PropertyType.offices:
      case PropertyType.clinics:
      case PropertyType.shops:
        if (property.floorNumber != null) {
          specs.add({localizations.translate(LangKeys.floor): '${property.floorNumber}'});
        }
        if (property.heatingType != null) {
          specs.add({localizations.translate(LangKeys.heatingSystem): localizations.translate(property.heatingType!)});
        }
        break;

      case PropertyType.buildings:
        if (property.totalFloors != null) {
          specs.add({localizations.translate(LangKeys.totalFloors): '${property.totalFloors}'});
        }
        break;

      case PropertyType.shops:
      case PropertyType.mallShops:
        if (property.shopLocation != null) {
          specs.add({localizations.translate(LangKeys.location): localizations.translate(property.shopLocation!)});
        }
        if (property.commercialActivity != null && property.commercialActivity!.isNotEmpty) {
          specs.add({localizations.translate(LangKeys.commercialActivity): property.commercialActivity!});
        }
        break;

      case PropertyType.lands:
        if (property.landType != null) {
          specs.add({localizations.translate(LangKeys.propertyType): localizations.translate(property.landType!)});
        }
        if (property.streetWidth != null) {
          specs.add({localizations.translate(LangKeys.streetWidth): '${property.streetWidth} ${localizations.translate(LangKeys.areaUnit)}'});
        }
        break;

      case PropertyType.farms:
        if (property.farmType != null) {
          specs.add({localizations.translate(LangKeys.propertyType): localizations.translate(property.farmType!)});
        }
        if (property.irrigationType != null) {
          specs.add({localizations.translate(LangKeys.irrigationLabel): localizations.translate(property.irrigationType!)});
        }
        if (property.crops != null && property.crops!.isNotEmpty) {
          specs.add({localizations.translate(LangKeys.crops): property.crops!});
        }
        break;

      case PropertyType.warehouses:
        if (property.warehouseHeight != null) {
          specs.add({localizations.translate(LangKeys.warehouseHeight): '${property.warehouseHeight}'});
        }
        if (property.warehouseFloorType != null) {
          specs.add({localizations.translate(LangKeys.warehouseFloorType): localizations.translate(property.warehouseFloorType!)});
        }
        break;

      case PropertyType.halls:
        if (property.hallCapacity != null) {
          specs.add({localizations.translate(LangKeys.hallCapacity): '${property.hallCapacity}'});
        }
        break;

      case PropertyType.workshops:
        if (property.workshopType != null && property.workshopType!.isNotEmpty) {
          specs.add({localizations.translate(LangKeys.workshopType): property.workshopType!});
        }
        if (property.workshopHeight != null) {
          specs.add({localizations.translate(LangKeys.workshopHeight): '${property.workshopHeight}'});
        }
        break;

      default:
        break;
    }

    if (specs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          localizations.translate(LangKeys.technicalSpecifications),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: specs.length,
          itemBuilder: (context, index) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  '${specs[index].keys.first}: ',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Expanded(
                  child: Text(
                    specs[index].values.first,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
