part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoaded extends LocationState {
  final List<String> recentSearches;
  final String? selectedLocation;

  const LocationLoaded({required this.recentSearches, this.selectedLocation});

  @override
  List<Object?> get props => [recentSearches, selectedLocation];
}
