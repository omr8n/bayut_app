import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/enums/property_enums.dart';

enum OnBoardingStep { intro, purpose, propertyType, location }

class OnBoardingState {
  final OnBoardingStep step;
  final ListingType? listingType; // بيع أو إيجار من مشروعك
  final PropertyType? propertyType; // نوع العقار من مشروعك
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
