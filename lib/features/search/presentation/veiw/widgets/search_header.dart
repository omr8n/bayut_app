import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/widgets/search_bar_widget.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onApply,
    this.selectedPropertyType,
    this.selectedListingType,
    this.minPrice, this.maxPrice, this.minArea, this.maxArea,
    this.governorate, this.finishType, this.ownershipType,
    this.direction, this.heatingType,
    this.landType, this.farmType, this.irrigationType, this.poolType, // 🔥
    this.minRooms, this.minBedrooms, this.minBathrooms, this.floorNumber,
    this.isLicensed, this.hasInstallment, this.isFeatured,
  });

  final TextEditingController controller;
  final void Function(String) onChanged;

  final void Function({
    PropertyType? propertyType,
    ListingType? listingType,
    double? minPrice, double? maxPrice,
    double? minArea, double? maxArea,
    String? governorate, String? finishType,
    String? ownershipType, String? direction,
    String? heatingType, String? landType,
    String? farmType, String? irrigationType,
    String? poolType, int? minRooms,
    int? minBedrooms, int? minBathrooms,
    int? floorNumber, bool? isLicensed,
    bool? hasInstallment, bool? isFeatured,
  }) onApply;

  final PropertyType? selectedPropertyType;
  final ListingType? selectedListingType;
  final double? minPrice, maxPrice, minArea, maxArea;
  final String? governorate, finishType, ownershipType, direction, heatingType;
  final String? landType, farmType, irrigationType, poolType;
  final int? minRooms, minBedrooms, minBathrooms, floorNumber;
  final bool? isLicensed, hasInstallment, isFeatured;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SearchBarWidget(
        controller: controller,
        onChanged: onChanged,
        onFilterTap: () {
          context.push(
            AppRoutes.filterScreen,
            extra: {
              'governorate': governorate,
              'propertyType': selectedPropertyType,
              'listingType': selectedListingType,
              'minPrice': minPrice, 'maxPrice': maxPrice,
              'minArea': minArea, 'maxArea': maxArea,
              'minRooms': minRooms, 'isFeatured': isFeatured,
              'isLicensed': isLicensed, 'hasInstallment': hasInstallment,
              'landType': landType, 'farmType': farmType,
              'irrigationType': irrigationType, 'poolType': poolType,
            },
          );
        },
      ),
    );
  }
}
