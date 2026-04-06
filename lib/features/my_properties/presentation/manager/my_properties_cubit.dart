import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/repos/property_repo/property_repo.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

abstract class MyPropertiesState {}

class MyPropertiesInitial extends MyPropertiesState {}

class MyPropertiesLoading extends MyPropertiesState {}

class MyPropertiesSuccess extends MyPropertiesState {
  final List<PropertyEntity> properties;
  MyPropertiesSuccess(this.properties);
}

class MyPropertiesFailure extends MyPropertiesState {
  final String errMessage;
  MyPropertiesFailure(this.errMessage);
}

class MyPropertiesCubit extends Cubit<MyPropertiesState> {
  final PropertyRepo productsRepo;
  MyPropertiesCubit(this.productsRepo) : super(MyPropertiesInitial());

  StreamSubscription? _propertiesSubscription;

  void fetchMyProperties(String sellerId) {
    if (isClosed) return;
    emit(MyPropertiesLoading());

    _propertiesSubscription?.cancel();
    _propertiesSubscription = productsRepo.getMyProperties(sellerId).listen((
      result,
    ) {
      if (isClosed) return;
      result.fold(
        (failure) => emit(MyPropertiesFailure(failure.message)),
        (properties) => emit(MyPropertiesSuccess(properties)),
      );
    });
  }

  // 🔥 تبديل حالة التميز
  Future<void> toggleFeatured(PropertyEntity property) async {
    final newStatus = !property.isFeatured;
    final result = await productsRepo.updatePropertyStatus(property.id, {
      'isFeatured': newStatus,
    });
    if (result.isLeft()) {
      result.fold((f) => emit(MyPropertiesFailure(f.message)), (_) {});
    }
  }

  // 🔥 تحديث حالة العقار مع حفظ السجل (History)
  Future<void> updatePropertyStatus(
    PropertyEntity property,
    PropertyStatus newStatus, {
    String? statusReason,
  }) async {
    final Map<String, dynamic> historyEntry = {
      'status': newStatus.name,
      'timestamp': DateTime.now().toIso8601String(),
      'reason': statusReason ?? (newStatus == PropertyStatus.sold ? 'تمت عملية البيع' : 'تحديث الحالة'),
    };

    final Map<String, dynamic> updates = {
      'status': newStatus.name,
      'statusHistory': historyEntry, // سيتم معالجته كـ arrayUnion في الـ Service
    };

    final result = await productsRepo.updatePropertyStatus(
      property.id,
      updates,
    );

    if (result.isLeft()) {
      result.fold((f) => emit(MyPropertiesFailure(f.message)), (_) {});
    }
  }

  Future<void> deleteProperty(String productId, String sellerId) async {
    final result = await productsRepo.deleteProperty(productId);
    result.fold((failure) {
      if (!isClosed) emit(MyPropertiesFailure(failure.message));
    }, (_) => {});
  }

  @override
  Future<void> close() {
    _propertiesSubscription?.cancel();
    return super.close();
  }
}
