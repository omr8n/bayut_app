import 'package:flutter/material.dart';
import 'package:test_graduation/core/widgets/search_bar_widget.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'package:test_graduation/features/search/presentation/veiw/widgets/filter_bottom_sheet.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onApply,
    required this.selectedPropertyType,
    required this.selectedListingType,
    required this.minPrice,
    required this.maxPrice,
    required this.minArea,
    required this.maxArea,
    this.governorate,
    this.finishType,
    this.ownershipType,
    this.direction,
    this.heatingType,
    this.landType,
    this.farmType,
    this.irrigationType,
    this.poolType,
    this.minRooms,
    this.minBedrooms,
    this.minBathrooms,
    this.floorNumber,
    this.isLicensed,
    this.hasInstallment,
  });

  final TextEditingController controller;
  final void Function(String) onChanged;

  final void Function({
    PropertyType? propertyType,
    ListingType? listingType,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
    String? governorate,
    String? finishType,
    String? ownershipType,
    String? direction,
    String? heatingType,
    String? landType,
    String? farmType,
    String? irrigationType,
    String? poolType,
    int? minRooms,
    int? minBedrooms,
    int? minBathrooms,
    int? floorNumber,
    bool? isLicensed,
    bool? hasInstallment,
  })
  onApply;

  final PropertyType? selectedPropertyType;
  final ListingType? selectedListingType;
  final double? minPrice;
  final double? maxPrice;
  final double? minArea;
  final double? maxArea;
  final String? governorate;
  final String? finishType;
  final String? ownershipType;
  final String? direction;
  final String? heatingType;
  final String? landType;
  final String? farmType;
  final String? irrigationType;
  final String? poolType;
  final int? minRooms;
  final int? minBedrooms;
  final int? minBathrooms;
  final int? floorNumber;
  final bool? isLicensed;
  final bool? hasInstallment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SearchBarWidget(
        controller: controller,
        onChanged: onChanged,
        onFilterTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) {
              return FilterBottomSheet(
                selectedPropertyType: selectedPropertyType,
                selectedListingType: selectedListingType,
                minPrice: minPrice,
                maxPrice: maxPrice,
                minArea: minArea,
                maxArea: maxArea,
                governorate: governorate,
                finishType: finishType,
                ownershipType: ownershipType,
                direction: direction,
                heatingType: heatingType,
                landType: landType,
                farmType: farmType,
                irrigationType: irrigationType,
                poolType: poolType,
                minRooms: minRooms,
                minBedrooms: minBedrooms,
                minBathrooms: minBathrooms,
                floorNumber: floorNumber,
                isLicensed: isLicensed,
                hasInstallment: hasInstallment,
                onApplyFilters: onApply,
              );
            },
          );
        },
      ),
    );
  }
}
