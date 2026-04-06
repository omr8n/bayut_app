import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import '../../repos/property_repo/property_repo.dart';

part 'property_state.dart';

class PropertyCubit extends Cubit<PropertyState> {
  final PropertyRepo propertyRepo;
  StreamSubscription? _streamSubscription;
  List<PropertyEntity> _allProperties = [];
  bool _isInitialLoad = true;

  PropertyCubit(this.propertyRepo) : super(PropertyInitial());

  Future<void> fetchProperties() async {
    emit(PropertyLoading());
    await _streamSubscription?.cancel();
    _streamSubscription = propertyRepo.getProperty().listen((result) {
      result.fold((failure) => emit(PropertyFailure(failure.message)),
          (properties) {
        _allProperties = properties;
        // أرسل البيانات فوراً لكل الأقسام دون أي فلترة بالموقع أو الغرض
        _emitClassifiedSuccess(_allProperties);
      });
    });
  }

  void _emitClassifiedSuccess(List<PropertyEntity> properties) {
    // 🔥 تصفية العقارات: استبعاد العقارات المباعة تماماً من الصفحة الرئيسية
    // يمكننا إبقاء "قيد التقسيط" أو استبعاده بناءً على رغبتك (هنا سنستبعد المباع فقط حالياً)
    final activeProperties = properties.where((p) => p.status != PropertyStatus.sold).toList();

    // ترتيب العقارات النشطة من الأحدث إلى الأقدم
    final sortedProperties = List<PropertyEntity>.from(activeProperties)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    emit(PropertySuccess(
      properties: sortedProperties,
      featuredProperties:
          sortedProperties.where((p) => p.isFeatured).toList(),
      recentProperties: sortedProperties,
      saleProperties: sortedProperties
          .where((p) => p.listingType == ListingType.sale)
          .toList(),
      rentProperties: sortedProperties
          .where((p) => p.listingType == ListingType.rent)
          .toList(),
    ));
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
