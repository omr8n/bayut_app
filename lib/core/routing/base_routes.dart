import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BaseRoute extends CustomTransitionPage {
  BaseRoute({required Widget child})
    : super(
        child: child,
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;

          final tween = Tween(begin: begin, end: end);

          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack, // 🔥 أحلى من linearToEaseOut
          );

          return ScaleTransition(
            scale: tween.animate(curvedAnimation),
            child: child,
          );
        },
      );
}
