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
          _emitClassifiedSuccess(properties);
        },
      );
    });
  }

  void _emitClassifiedSuccess(List<PropertyEntity> properties) {
    final sorted = List<PropertyEntity>.from(properties)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    emit(PropertySuccess(
      properties: sorted, // 🔥 القائمة الكاملة المفلترة للبحث
      featuredProperties: sorted.where((p) => p.isFeatured).toList(),
      recentProperties: sorted.where((p) => !p.isFeatured).toList(),
      saleProperties: sorted.where((p) => p.listingType == ListingType.sale).toList(),
      rentProperties: sorted.where((p) => p.listingType == ListingType.rent).toList(),
    ));
  }

  /// 🔥 وظيفة البحث المباشر (المطلوبة في HomeView)
  void searchProperties(String query) {
    applyFilters(query: query);
  }

  /// محرك الفلترة الشامل
  void applyFilters({
    String? query,
    PropertyType? propertyType,
    ListingType? listingType,
    double? minPrice, double? maxPrice,
    double? minArea, double? maxArea,
    String? governorate,
    String sortBy = 'newest',
  }) {
    List<PropertyEntity> filtered = _allProperties.where((p) {
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        if (!p.title.toLowerCase().contains(q) && !p.location.toLowerCase().contains(q)) return false;
      }
      if (propertyType != null && p.type != propertyType) return false;
      if (listingType != null && p.listingType != listingType) return false;
      if (minPrice != null && p.price < minPrice) return false;
      if (maxPrice != null && p.price > maxPrice) return false;
      if (minArea != null && p.area < minArea) return false;
      if (maxArea != null && p.area > maxArea) return false;
      if (governorate != null && p.governorate != governorate) return false;
      return true;
    }).toList();

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
