// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../constants/theme_data.dart';
// import '../../services/shared_preferences_singleton.dart';
// import 'theme_state.dart';

// class ThemeCubit extends Cubit<ThemeState> {
//   ThemeCubit() : super(ThemeInitial()) {
//     loadTheme();
//   }

//   final String prefsKey = "isDarkMode";

//   Future<void> loadTheme() async {
//     try {
//       final isDarkMode = Prefs.getBool(prefsKey);
//       if (isDarkMode) {
//         emit(DarkThemeState(themeData: MyThemeData.darkTheme));
//       } else {
//         emit(LightThemeState(themeData: MyThemeData.lightTheme));
//       }
//     } catch (_) {
//       emit(ThemeError());
//     }
//   }

//   Future<void> toggleTheme() async {
//     final currentState = state;
//     try {
//       if (currentState is LightThemeState) {
//         emit(DarkThemeState(themeData: MyThemeData.darkTheme));
//         Prefs.setBool(prefsKey, true);
//       } else {
//         emit(LightThemeState(themeData: MyThemeData.lightTheme));
//         Prefs.setBool(prefsKey, false);
//       }
//     } catch (_) {
//       emit(ThemeError());
//     }
//   }
// }
