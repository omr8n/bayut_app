part of 'app_cubit.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {}

class ThemeChangeModeState extends AppState {
  final bool isDark;
  const ThemeChangeModeState({required this.isDark});

  @override
  List<Object?> get props => [isDark];
}

class LanguageChangeState extends AppState {
  final Locale locale;
  const LanguageChangeState({required this.locale});

  @override
  List<Object?> get props => [locale];
}
