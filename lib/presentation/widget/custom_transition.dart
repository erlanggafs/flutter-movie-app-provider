import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Page<T> slideTransitionPage<T>({
  required Widget child,
  required LocalKey key,
  required Offset beginOffset,
  Duration duration = const Duration(milliseconds: 300),
  Curve curve = Curves.easeInOut,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(begin: beginOffset, end: Offset.zero)
          .chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
