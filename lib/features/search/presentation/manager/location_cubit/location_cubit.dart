import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  String? selectedLocation;
  List<String> recentSearches = [];

  void init() {
    recentSearches = Prefs.getStringList('search_history') ?? [];
    emit(LocationLoaded(recentSearches: recentSearches, selectedLocation: selectedLocation));
  }

  void selectLocation(String loc) {
    selectedLocation = loc;
    emit(LocationLoaded(recentSearches: recentSearches, selectedLocation: selectedLocation));
  }

  void clearAll() {
    selectedLocation = null;
    emit(LocationLoaded(recentSearches: recentSearches, selectedLocation: null));
  }

  void saveToHistory(String loc) {
    if (loc.isEmpty) return;
    if (!recentSearches.contains(loc)) {
      recentSearches.insert(0, loc);
      if (recentSearches.length > 5) recentSearches.removeLast();
      Prefs.setStringList('search_history', recentSearches);
    }
    Prefs.setString('user_location', loc);
  }
}
