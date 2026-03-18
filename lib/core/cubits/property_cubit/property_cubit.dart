import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import '../../repos/products_repo/products_repo.dart';

part 'property_state.dart';

class PropertyCubit extends Cubit<PropertyState> {
  final ProductsRepo propertyRepo;
  StreamSubscription? _streamSubscription;
  List<PropertyEntity> _allProperties = [];

  PropertyCubit(this.propertyRepo) : super(PropertyInitial());

  Future<void> fetchProperties() async {
    emit(PropertyLoading());
    await _streamSubscription?.cancel();
    _streamSubscription = propertyRepo.getProducts().listen((result) {
      result.fold(
        (failure) => emit(PropertyFailure(failure.message)),
        (properties) {
          _allProperties = properties;
          applyFilters(); // تطبيق الترتيب الافتراضي فور الجلب
        },
      );
    });
  }

  void _emitClassifiedSuccess(List<PropertyEntity> properties) {
    emit(PropertySuccess(
      properties: properties,
      featuredProperties: properties.where((p) => p.isFeatured).toList(),
      recentProperties: properties.where((p) => !p.isFeatured).toList(),
      saleProperties: properties.where((p) => p.listingType == ListingType.sale).toList(),
      rentProperties: properties.where((p) => p.listingType == ListingType.rent).toList(),
    ));
  }

  void searchProperties(String query) {
    applyFilters(query: query);
  }

  /// 🔥 المحرك الشامل لكافة أنواع الفلترة والبحث والترتيب
  void applyFilters({
    String? query,
    PropertyType? propertyType,
    ListingType? listingType,
    double? minPrice, double? maxPrice,
    double? minArea, double? maxArea,
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
    String sortBy = 'newest',
  }) {
    List<PropertyEntity> filtered = _allProperties.where((p) {
      // 1. بحث نصي (العنوان، المحافظة، المدينة)
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        if (!p.title.toLowerCase().contains(q) && 
            !p.location.toLowerCase().contains(q) &&
            !p.city.toLowerCase().contains(q)) return false;
      }

      // 2. الفلاتر الأساسية
      if (propertyType != null && p.type != propertyType) return false;
      if (listingType != null && p.listingType != listingType) return false;
      if (minPrice != null && p.price < minPrice) return false;
      if (maxPrice != null && p.price > maxPrice) return false;
      if (minArea != null && p.area < minArea) return false;
      if (maxArea != null && p.area > maxArea) {
        return false;
      }
      if (governorate != null && p.governorate != governorate) return false;

      // 3. الفلاتر المتقدمة (الكسوة، الملكية، الاتجاه)
      if (finishType != null && p.finishType != finishType) return false;
      if (ownershipType != null && p.ownershipType != ownershipType) return false;
      if (direction != null && p.direction != direction) return false;
      if (heatingType != null && p.heatingType != heatingType) return false;
      if (landType != null && p.landType != landType) return false;
      if (farmType != null && p.farmType != farmType) return false;
      if (irrigationType != null && p.irrigationType != irrigationType) return false;
      if (poolType != null && p.poolType != poolType) return false;

      // 4. فلاتر الأعداد (غرف، حمامات، طابق)
      if (minRooms != null && (p.totalRooms ?? 0) < minRooms) return false;
      if (minBedrooms != null && (p.bedrooms ?? 0) < minBedrooms) return false;
      if (minBathrooms != null && (p.bathrooms ?? 0) < minBathrooms) return false;
      if (floorNumber != null && p.floorNumber != floorNumber) return false;

      // 5. فلاتر بوليان (مرخص، تقسيط)
      if (isLicensed != null && p.isLicensed != isLicensed) return false;
      if (hasInstallment != null && p.hasInstallment != hasInstallment) return false;

      return true;
    }).toList();

    // 6. تطبيق الترتيب المختار
    if (sortBy == 'priceLowToHigh') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == 'priceHighToLow') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    } else if (sortBy == 'areaLargest') {
      filtered.sort((a, b) => b.area.compareTo(a.area));
    } else {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    _emitClassifiedSuccess(filtered);
  }

  @override
  Future<void> close() { _streamSubscription?.cancel(); return super.close(); }
}
