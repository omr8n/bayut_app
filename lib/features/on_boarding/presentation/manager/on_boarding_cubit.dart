import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';

enum OnBoardingStep { intro, purpose, propertyType, location }

class OnBoardingState {
  final OnBoardingStep step;
  final ListingType? listingType;
  final PropertyType? propertyType;
  final List<String> selectedLocations;

  OnBoardingState({
    this.step = OnBoardingStep.intro,
    this.listingType,
    this.propertyType,
    this.selectedLocations = const [],
  });

  OnBoardingState copyWith({
    OnBoardingStep? step,
    ListingType? listingType,
    PropertyType? propertyType,
    List<String>? selectedLocations,
  }) {
    return OnBoardingState(
      step: step ?? this.step,
      listingType: listingType ?? this.listingType,
      propertyType: propertyType ?? this.propertyType,
      selectedLocations: selectedLocations ?? this.selectedLocations,
    );
  }
}

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingState());

  void nextStep() {
    if (state.step == OnBoardingStep.intro) {
      emit(state.copyWith(step: OnBoardingStep.purpose));
    } else if (state.step == OnBoardingStep.purpose) {
      emit(state.copyWith(step: OnBoardingStep.propertyType));
    } else if (state.step == OnBoardingStep.propertyType) {
      emit(state.copyWith(step: OnBoardingStep.location));
    }
  }

  // 🔥 دالة حفظ التفضيلات الموحدة
  Future<void> completeOnBoarding() async {
    // 1. حفظ الغرض
    if (state.listingType != null) {
      Prefs.setString('user_purpose', state.listingType == ListingType.sale ? 'buy' : 'rent');
    }
    
    // 2. حفظ نوع العقار
    if (state.propertyType != null) {
      Prefs.setString('user_property_type', state.propertyType!.name);
    }

    // 3. 🔥 توحيد المحافظة: حفظ أول محافظة مختارة لكي يقرأها الفلتر
    if (state.selectedLocations.isNotEmpty) {
      // نأخذ أول محافظة اختارها المستخدم لتكون هي القيمة الافتراضية للبحث
      Prefs.setString('user_location', state.selectedLocations.first);
      Prefs.setStringList('user_selected_locations', state.selectedLocations);
    }

    Prefs.setBool('isOnBoardingSeen', true);
  }

  void previousStep() {
    if (state.step == OnBoardingStep.purpose) {
      emit(state.copyWith(step: OnBoardingStep.intro));
    } else if (state.step == OnBoardingStep.propertyType) {
      emit(state.copyWith(step: OnBoardingStep.purpose));
    } else if (state.step == OnBoardingStep.location) {
      emit(state.copyWith(step: OnBoardingStep.propertyType));
    }
  }

  void setListingType(ListingType type) {
    emit(state.copyWith(listingType: type));
  }

  void setPropertyType(PropertyType type) {
    emit(state.copyWith(propertyType: type));
  }

  void toggleLocation(String location) {
    final List<String> updated = List.from(state.selectedLocations);
    if (updated.contains(location)) {
      updated.remove(location);
    } else {
      updated.add(location);
    }
    emit(state.copyWith(selectedLocations: updated));
  }
}
