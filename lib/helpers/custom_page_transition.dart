// import 'package:flutter/material.dart';
//
// class CustomPageRoute extends PageRouteBuilder {
//   Widget route;
//   WidgetBuilder builder;
//   CustomPageRoute({
//     @required this.builder,
//     this.route,
//     Duration duration,
//   })  : assert(route == null || builder == null),
//         super(
//           pageBuilder: (context, animation, secondaryAnimation) => route ?? builder(context),
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             return FadeTransition(opacity: animation, child: child);
//           },
//           transitionDuration: duration ?? Duration(milliseconds: 200),
//         );
// }
