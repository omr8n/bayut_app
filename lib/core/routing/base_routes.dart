import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BaseRoute extends CustomTransitionPage {
  BaseRoute({required Widget child})
    : super(
        child: child,
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Determine if the direction is RTL (Arabic)
          final bool isRTL = Directionality.of(context) == TextDirection.rtl;

          // Slide transition: Start from left if RTL, right if LTR
          final slideTween = Tween<Offset>(
            begin: Offset(isRTL ? -1.0 : 1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.fastOutSlowIn));

          // Fade transition for extra smoothness
          final fadeTween = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeIn));

          return SlideTransition(
            position: animation.drive(slideTween),
            child: FadeTransition(
              opacity: animation.drive(fadeTween),
              child: child,
            ),
          );
        },
      );
}
