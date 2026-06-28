import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/services/connectivity_service.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import '../../repos/property_repo/property_repo.dart';

part 'property_state.dart';

class PropertyCubit extends Cubit<PropertyState> {
  final PropertyRepo _propertyRepo;
  final ConnectivityService _connectivityService;
  
  StreamSubscription? _streamSubscription;
  StreamSubscription? _connectivitySubscription;
  List<PropertyEntity> _allProperties = [];

  PropertyCubit(this._propertyRepo, this._connectivityService) : super(PropertyInitial()) {
    _monitorConnectivity();
  }

  void _monitorConnectivity() {
    _connectivitySubscription = _connectivityService.connectivityStream.listen((results) {
      final isConnected = !results.contains(ConnectivityResult.none) && results.isNotEmpty;
      
      if (!isConnected) {
        if (state is PropertySuccess) {
          final successState = state as PropertySuccess;
          emit(PropertySuccess(
            properties: successState.properties,
            featuredProperties: successState.featuredProperties,
            trendingProperties: successState.trendingProperties,
            recentProperties: successState.recentProperties,
            saleProperties: successState.saleProperties,
            rentProperties: successState.rentProperties,
            isOffline: true,
          ));
        } else {
          emit(const PropertyFailure(LangKeys.noInternet));
        }
      } else {
        // عودة الإنترنت
        if (state is PropertyFailure || state is PropertyInitial || (state is PropertySuccess && (state as PropertySuccess).isOffline)) {
          fetchProperties();
        }
      }
    });
  }

  // ✅ جلب البيانات: إذا طلب المستخدم التحديث يدوياً (Refresh)
  Future<void> fetchProperties({bool isRefresh = false}) async {
    final isConnected = await _connectivityService.isConnected;
    
    if (!isConnected) {
      // إذا كان يطلب تحديث يدوياً (Refresh) وما في نت، نجبره يروح لحالة الفشل لإظهار الصورة
      if (isRefresh || _allProperties.isEmpty) {
        emit(const PropertyFailure(LangKeys.noInternet));
      }
      return;
    }

    emit(PropertyLoading());
    
    await _streamSubscription?.cancel();
    _streamSubscription = _propertyRepo.getProperty().listen(
      (result) {
        result.fold(
          (failure) {
            if (_allProperties.isEmpty) {
              emit(PropertyFailure(failure.message));
            }
          },
          (properties) {
            _allProperties = properties;
            _emitClassifiedSuccess(_allProperties, isOffline: false);
          },
        );
      },
      onError: (error) {
        if (_allProperties.isEmpty) {
          emit(PropertyFailure(error.toString()));
        }
      },
    );
  }

  void _emitClassifiedSuccess(List<PropertyEntity> properties, {bool isOffline = false}) {
    final activeProperties = properties
        .where((p) => p.status != PropertyStatus.sold)
        .toList();

    final sortedProperties = List<PropertyEntity>.from(activeProperties)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // 🔥 منطق التريند: أعلى 5 مشاهدات (مؤقتاً نعتمد على views، وسنقوم بتطويرها لاحقاً لتعتمد على آخر 30 يوم)
    final trendingProperties = List<PropertyEntity>.from(activeProperties)
      ..sort((a, b) => b.views.compareTo(a.views));
    final top5Trending = trendingProperties.take(5).toList();

    emit(
      PropertySuccess(
        properties: sortedProperties,
        featuredProperties: sortedProperties.where((p) => p.isFeatured).toList(),
        trendingProperties: top5Trending,
        recentProperties: sortedProperties,
        saleProperties: sortedProperties.where((p) => p.listingType == ListingType.sale).toList(),
        rentProperties: sortedProperties.where((p) => p.listingType == ListingType.rent).toList(),
        isOffline: isOffline,
      ),
    );
  }

  @override
  Future<void> close() {
    // 🔥 كـ Singleton، نحن لا نغلق الـ Cubit أبداً لضمان عدم حدوث Bad State
    // بل نقوم فقط بإلغاء الاشتراكات لتجنب تسريب الذاكرة (Memory Leak)
    _streamSubscription?.cancel();
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
