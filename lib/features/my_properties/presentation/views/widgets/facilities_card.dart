import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/core/utils/colors.dart';

class FacilitiesCard extends StatelessWidget {
  final PropertyType selectedPropertyType;
  final Map<String, Map<String, dynamic>> commonFacilities;
  final Map<String, Map<String, dynamic>> villaFacilities;
  final Map<String, Map<String, dynamic>> shopFacilities;
  final Map<String, Map<String, dynamic>> landFacilities;
  final Map<String, Map<String, dynamic>> farmFacilities;
  final Map<String, Map<String, dynamic>> poolFacilities;
  final Map<String, Map<String, dynamic>> clinicFacilities;
  final Map<String, Map<String, dynamic>> warehouseFacilities;
  final Map<String, Map<String, dynamic>> hallFacilities;
  final Map<String, Map<String, dynamic>> officeFacilities;
  final Map<String, Map<String, dynamic>> workshopFacilities;
  final Function(String) onFacilityToggle;

  const FacilitiesCard({
    super.key,
    required this.selectedPropertyType,
    required this.commonFacilities,
    required this.villaFacilities,
    required this.shopFacilities,
    required this.landFacilities,
    required this.farmFacilities,
    required this.poolFacilities,
    required this.clinicFacilities,
    required this.warehouseFacilities,
    required this.hallFacilities,
    required this.officeFacilities,
    required this.workshopFacilities,
    required this.onFacilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, dynamic>> facilities;
    if (selectedPropertyType == PropertyType.villas) {
      facilities = villaFacilities;
    } else if (selectedPropertyType == PropertyType.shops ||
        selectedPropertyType == PropertyType.mallShops) {
      facilities = shopFacilities;
    } else if (selectedPropertyType == PropertyType.lands) {
      facilities = landFacilities;
    } else if (selectedPropertyType == PropertyType.farms) {
      facilities = farmFacilities;
    } else if (selectedPropertyType == PropertyType.pools) {
      facilities = poolFacilities;
    } else if (selectedPropertyType == PropertyType.clinics) {
      facilities = clinicFacilities;
    } else if (selectedPropertyType == PropertyType.warehouses) {
      facilities = warehouseFacilities;
    } else if (selectedPropertyType == PropertyType.halls) {
      facilities = hallFacilities;
    } else if (selectedPropertyType == PropertyType.offices) {
      facilities = officeFacilities;
    } else if (selectedPropertyType == PropertyType.workshops) {
      facilities = workshopFacilities;
    } else {
      facilities = commonFacilities;
    }

    return Column(
      children: facilities.keys.map((key) {
        bool isSelected = facilities[key]!['value'] as bool;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            onTap: () => onFacilityToggle(key),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade300,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  const Spacer(),
                  Text(
                    key,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    facilities[key]!['icon'] as IconData,
                    color: isSelected ? AppColors.primary : Colors.grey.shade600,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
