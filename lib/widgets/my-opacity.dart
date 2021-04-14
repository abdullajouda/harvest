import 'package:flutter/material.dart';

class MyOpacity extends StatelessWidget {
  final bool load;
  final Widget child;

  const MyOpacity({Key key, this.load, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        duration: Duration(milliseconds: 500),
    opacity: load ? 0 : 1,
    child:child);
  }
}
