import 'package:flutter/material.dart';

SlideTransition slidetransitionright(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {

final width = MediaQuery.of(context).size.width;

  return SlideTransition(
    position: Tween<Offset>(
      begin: Offset(width/2, 0.0),
      end: Offset.zero,
    ).animate(animation),
    child: SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: Offset(-width/5, 0.0),
      ).animate(secondaryAnimation),
      child: child,
    ),
  );
}


SlideTransition slidetransitionleft(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {

final width = MediaQuery.of(context).size.width;

  return SlideTransition(
    position: Tween<Offset>(
      begin: Offset(-width, 0.0),
      end: Offset.zero,
    ).animate(animation),
    child: SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: Offset(width, 0.0),
      ).animate(secondaryAnimation),
      child: child,
    ),
  );
}
