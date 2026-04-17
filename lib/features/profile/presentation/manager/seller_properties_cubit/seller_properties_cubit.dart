import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/repos/property_repo/property_repo.dart';

import 'seller_properties_state.dart';

class SellerPropertiesCubit extends Cubit<SellerPropertiesState> {
  final PropertyRepo propertyRepo;
  StreamSubscription? _subscription;

  SellerPropertiesCubit(this.propertyRepo) : super(SellerPropertiesInitial());

  void fetchSellerProperties(String sellerId) {
    emit(SellerPropertiesLoading());
    _subscription?.cancel();
    _subscription = propertyRepo.getMyProperties(sellerId).listen((result) {
      if (isClosed) return;
      result.fold(
        (failure) => emit(SellerPropertiesFailure(failure.message)),
        (properties) => emit(SellerPropertiesSuccess(properties)),
      );
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
