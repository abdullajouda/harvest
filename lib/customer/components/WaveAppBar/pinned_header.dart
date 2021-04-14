import 'package:flutter/material.dart';

@immutable
class PinnedTopHeader {
  final Widget child;
  final double maxHeight;
  final double minHeight;
  final bool pinned;
  final EdgeInsetsGeometry margin;
  const PinnedTopHeader({
    @required this.child,
    @required this.maxHeight,
    this.minHeight,
    this.pinned = true,
    this.margin = EdgeInsets.zero,
  }) : assert(child != null && maxHeight != null, "You should supply maxHeight and child");
}
