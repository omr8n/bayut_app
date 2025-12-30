import 'package:flutter/material.dart';
import 'package:test_graduation/core/models/property_model.dart';
import 'filter_form.dart';

class FilterBottomSheet extends StatelessWidget {
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
  onApplyFilters;

  const FilterBottomSheet({
    super.key,
    this.selectedPropertyType,
    this.selectedListingType,
    this.minPrice,
    this.maxPrice,
    this.minArea,
    this.maxArea,
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
    required this.onApplyFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: FilterForm(
          selectedListingType: selectedListingType,
          selectedPropertyType: selectedPropertyType,
          minPrice: minPrice,
          maxPrice: maxPrice,
          minArea: minArea,
          maxArea: maxArea,
          selectedGovernorate: governorate,
          selectedFinishType: finishType,
          selectedOwnershipType: ownershipType,
          // selectedDirection: direction,
          // selectedHeatingType: heatingType,
          // selectedLandType: landType,
          // selectedFarmType: farmType,
          // selectedIrrigationType: irrigationType,
          // selectedPoolType: poolType,
          minRooms: minRooms,
          // minBedrooms: minBedrooms,
          minBathrooms: minBathrooms,
          // floorNumber: floorNumber,
          isLicensed: isLicensed,
          hasInstallment: hasInstallment,
          onApplyFilters: onApplyFilters,
        ),
      ),
    );
  }
}
