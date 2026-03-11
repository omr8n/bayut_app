import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import '../../repos/products_repo/products_repo.dart';

part 'property_state.dart';

class PropertyCubit extends Cubit<PropertyState> {
  final ProductsRepo propertyRepo;
  StreamSubscription? _streamSubscription;
  List<PropertyEntity> _allProperties = [];

  PropertyCubit(this.propertyRepo) : super(PropertyInitial());

  /// وظيفة جلب كافة العقارات وتوزيعها تلقائياً
  Future<void> fetchProperties() async {
    emit(PropertyLoading());

    await _streamSubscription?.cancel();

    _streamSubscription = propertyRepo.getProducts().listen((result) {
      result.fold(
        (failure) => emit(PropertyFailure(failure.message)), // استخدام .message كما في كلاس Failure
        (properties) {
          _allProperties = properties;
          _emitClassifiedSuccess(properties);
        },
      );
    });
  }

  /// وظيفة داخلية لتصنيف العقارات وإرسالها للواجهة
  void _emitClassifiedSuccess(List<PropertyEntity> properties) {
    // 1. العقارات المميزة (Featured)
    final featured = properties.where((p) => p.isFeatured).toList();
    
    // 2. أحدث العقارات (مرتبة من الأحدث للأقدم)
    final recent = properties.where((p) => !p.isFeatured).toList().reversed.toList();

    emit(PropertySuccess(
      featuredProperties: featured,
      recentProperties: recent,
    ));
  }

  /// البحث السريع في العقارات
  void searchProperties(String query) {
    if (query.isEmpty) {
      _emitClassifiedSuccess(_allProperties);
      return;
    }

    final filtered = _allProperties.where((p) {
      return p.title.toLowerCase().contains(query.toLowerCase()) ||
             p.city.toLowerCase().contains(query.toLowerCase()) ||
             p.governorate.toLowerCase().contains(query.toLowerCase());
    }).toList();

    _emitClassifiedSuccess(filtered);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
