import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      final currentStateName = transition.currentState.runtimeType.toString();
      final nextStateName = transition.nextState.runtimeType.toString();
      log('🔵 [${bloc.runtimeType}] Transition: $currentStateName -> $nextStateName');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      final currentStateName = change.currentState.runtimeType.toString();
      final nextStateName = change.nextState.runtimeType.toString();
      
      // تجنب طباعة المحتوى الكامل للقوائم
      log('🟢 [${bloc.runtimeType}] Change: $currentStateName -> $nextStateName');
    }
  }
}
