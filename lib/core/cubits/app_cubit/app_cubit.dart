import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  bool isDark = false;
  String currentLangCode = 'ar';

  // Theme Mode
  Future<void> changeAppThemeMode({bool? sharedMode}) async {
    if (sharedMode != null) {
      isDark = sharedMode;
    } else {
      isDark = !isDark;
    }
    Prefs.setBool('isDarkMode', isDark);
    emit(ThemeChangeModeState(isDark: isDark));
  }

  // Language Change
  void getSavedLanguage() {
    currentLangCode = Prefs.getString('language').isEmpty
        ? 'ar'
        : Prefs.getString('language');

    isDark = Prefs.getBool('isDarkMode');

    emit(LanguageChangeState(locale: Locale(currentLangCode)));
    emit(ThemeChangeModeState(isDark: isDark));
  }

  Future<void> _changeLang(String langCode) async {
    await Prefs.setString('language', langCode);
    currentLangCode = langCode;
    emit(LanguageChangeState(locale: Locale(currentLangCode)));
  }

  void toArabic() => _changeLang('ar');

  void toEnglish() => _changeLang('en');
}
