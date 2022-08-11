import 'package:flutter/material.dart';

class FadeTransiton<T> extends PageRoute<T> {
  FadeTransiton(this.child, this.duration);
  @override
  Color get barrierColor => Colors.black;

  @override
  String? get barrierLabel => null;

  final Widget child;
  final int duration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: duration);
}
