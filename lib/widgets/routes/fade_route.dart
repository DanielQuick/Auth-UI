import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({
    this.page,
  }) : super(
          transitionDuration: Duration(milliseconds: 200),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween(
              begin: Offset.zero,
              end: const Offset(-0.1, 0),
            ).animate(secondaryAnimation),
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0.1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: Opacity(
                  opacity: 1-secondaryAnimation.value,
                  child: child,
                ),
              ),
            ),
          ),
        );
}
