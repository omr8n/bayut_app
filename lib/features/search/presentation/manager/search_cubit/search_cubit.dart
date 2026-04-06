import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import '../../../../../core/repos/property_repo/property_repo.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final PropertyRepo propertyRepo;
  StreamSubscription? _streamSubscription;
  List<PropertyEntity> _allProperties = [];

  // 🔥 ذاكرة الجلسة الشاملة (تصفر فقط عند إغلاق التطبيق)
  PropertyType? currentPropertyType;
  ListingType? currentListingType;
  double? currentMinPrice, currentMaxPrice, currentMinArea, currentMaxArea;
  int? currentRooms, currentBedrooms, currentBathrooms, currentFloor;
  bool? currentLicensed, currentInstallment, currentFeatured;
  String? currentGovernorate,
      currentFinishType,
      currentOwnershipType,
      currentDirection,
      currentHeatingType;
  String? currentLandType,
      currentFarmType,
      currentIrrigationType,
      currentPoolType;
  String? currentQuery;
  String currentSortBy = 'newest';

  SearchCubit(this.propertyRepo) : super(SearchInitial()) {
    _initFromPrefs();
  }

  Future<void> fetchAllPropertiesForSearch({bool resetFilters = false}) async {
    emit(SearchLoading());
    await _streamSubscription?.cancel();
    _streamSubscription = propertyRepo.getProperty().listen((result) {
      result.fold((failure) => emit(SearchFailure(failure.message)), (
        properties,
      ) {
        _allProperties = properties;
        
        if (resetFilters) {
          _initFromPrefs();
        } else {
          // 🔥 تحديث البيانات مع الحفاظ على الفلاتر الحالية
          applyFilters(
            propertyType: currentPropertyType,
            listingType: currentListingType,
            governorate: currentGovernorate,
            minPrice: currentMinPrice,
            maxPrice: currentMaxPrice,
            minArea: currentMinArea,
            maxArea: currentMaxArea,
            minRooms: currentRooms,
            minBedrooms: currentBedrooms,
            minBathrooms: currentBathrooms,
            floorNumber: currentFloor,
            isLicensed: currentLicensed,
            hasInstallment: currentInstallment,
            isFeatured: currentFeatured,
            query: currentQuery,
          );
        }
      });
    });
  }

  void _initFromPrefs() {
    final String? purpose = Prefs.getString('user_purpose');
    final String? typeName = Prefs.getString('user_property_type');
    final String? location = Prefs.getString('user_location');

    ListingType? initialListingType = purpose == 'buy'
        ? ListingType.sale
        : (purpose == 'rent' ? ListingType.rent : null);

    PropertyType? initialPropertyType;
    if (typeName != null && typeName.isNotEmpty) {
      try {
        initialPropertyType = PropertyType.values.firstWhere(
          (e) => e.name == typeName,
        );
      } catch (_) {}
    }

    String? initialGovernorate = (location == 'الكل' || location == '')
        ? null
        : location;

    // 🔥 تمرير القيم الصريحة للدالة لضمان عدم تصفيرها عند البداية
    applyFilters(
      listingType: initialListingType,
      propertyType: initialPropertyType,
      governorate: initialGovernorate,
    );
  }

  void resetSessionFilters() {
    currentPropertyType = null;
    currentListingType = null;
    currentGovernorate = null;
    currentMinPrice = null;
    currentMaxPrice = null;
    currentMinArea = null;
    currentMaxArea = null;
    currentRooms = null;
    currentBedrooms = null;
    currentBathrooms = null;
    currentFloor = null;
    currentLicensed = null;
    currentInstallment = null;
    currentFeatured = null;
    currentFinishType = null;
    currentOwnershipType = null;
    currentDirection = null;
    currentHeatingType = null;
    currentLandType = null;
    currentFarmType = null;
    currentIrrigationType = null;
    currentPoolType = null;
    applyFilters();
  }

  void applyFilters({
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
    bool? isFeatured,
    String? query,
    bool hideSold = true,
    String? sortBy,
    bool isExplicitNull = false,
  }) {
    emit(SearchLoading());

    // 🎯 تحديث الذاكرة الحية
    // الاختيارات الأساسية (تحتاج ذكاء للحفاظ على الـ Onboarding)
    if (propertyType != null || isExplicitNull) currentPropertyType = propertyType;
    if (listingType != null || isExplicitNull) currentListingType = listingType;
    if (governorate != null || isExplicitNull) currentGovernorate = governorate;

    // باقي الفلاتر (يجب أن تقبل null مباشرة للتحديث اللحظي)
    currentMinPrice = minPrice;
    currentMaxPrice = maxPrice;
    currentMinArea = minArea;
    currentMaxArea = maxArea;
    currentRooms = minRooms;
    currentBedrooms = minBedrooms;
    currentBathrooms = minBathrooms;
    currentFloor = floorNumber;
    currentLicensed = isLicensed;
    currentInstallment = hasInstallment;
    currentFeatured = isFeatured;
    currentQuery = query ?? currentQuery;
    currentSortBy = sortBy ?? currentSortBy;
    
    // 💾 المزامنة مع Prefs
    if (currentPropertyType != null) Prefs.setString('user_property_type', currentPropertyType!.name);
    if (currentListingType != null) {
      Prefs.setString('user_purpose', currentListingType == ListingType.sale ? 'buy' : 'rent');
    }
    Prefs.setString('user_location', currentGovernorate ?? 'الكل');

    List<PropertyEntity> filtered = _allProperties.where((p) {
      if (hideSold && p.status == PropertyStatus.sold) return false;
      if (currentFeatured == true && !p.isFeatured) return false;
      if (currentLicensed == true && !p.isLicensed) return false;
      if (currentInstallment == true && !p.hasInstallment) return false;

      if (currentQuery != null && currentQuery!.isNotEmpty) {
        final q = currentQuery!.toLowerCase();
        if (!p.title.toLowerCase().contains(q) &&
            !p.location.toLowerCase().contains(q))
          return false;
      }

      if (currentPropertyType != null && p.type != currentPropertyType)
        return false;
      if (currentListingType != null && p.listingType != currentListingType)
        return false;
      if (currentGovernorate != null &&
          currentGovernorate != 'الكل' &&
          p.governorate != currentGovernorate)
        return false;

      // تصفية السعر
      if (currentMinPrice != null && p.price < currentMinPrice!) return false;
      if (currentMaxPrice != null && p.price > currentMaxPrice!) return false;
      
      // تصفية المساحة
      if (currentMinArea != null && (p.area ?? 0) < currentMinArea!) return false;
      if (currentMaxArea != null && (p.area ?? 0) > currentMaxArea!) return false;

      // تصفية الغرف والحمامات
      if (currentRooms != null && (p.totalRooms ?? 0) < currentRooms!) return false;
      if (currentBedrooms != null && (p.bedrooms ?? 0) < currentBedrooms!) return false;
      if (currentBathrooms != null && (p.bathrooms ?? 0) < currentBathrooms!) return false;
      
      // تصفية الطابق
      if (currentFloor != null && p.floorNumber != currentFloor) return false;

      return true;
    }).toList();

    // 🏆 الترتيب
    _sortProperties(filtered);

    emit(SearchSuccess(filtered));
  }

  void _sortProperties(List<PropertyEntity> properties) {
    switch (currentSortBy) {
      case 'newest':
        properties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'priceLowToHigh':
        properties.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'priceHighToLow':
        properties.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'areaLargest':
        properties.sort((a, b) => b.area.compareTo(a.area));
        break;
    }
  }

  void saveSearchHistory(String query) {
    if (query.trim().isEmpty) return;
    List<String> history = Prefs.getStringList('search_history') ?? [];
    if (!history.contains(query.trim())) {
      history.insert(0, query.trim());
      if (history.length > 5) history.removeLast();
      Prefs.setStringList('search_history', history);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
