import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';

class MakeFavoriteButton extends StatelessWidget {
  final VoidCallback onValueChanged;
  final bool value;
  final Color activeColor;
  final Color inActiveColor;
  final EdgeInsetsGeometry padding;
  final bool show;
  final double size;

  const MakeFavoriteButton({
    Key key,
    this.onValueChanged,
    this.value = false,
    this.activeColor,
    this.inActiveColor,
    this.padding,
    this.show = true,
    this.size = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = Size(size, size);
    if (!show) return SizedBox();
    Widget icon;
    if (!value) {
      icon = SvgPicture.asset(
        Constants.heartOuline,
        width: _size.width,
        height: _size.height,
        color: inActiveColor ?? Colors.grey[300],
      );
    } else {
      icon = SvgPicture.asset(
        Constants.heart,
        width: _size.width,
        height: _size.height,
        color: activeColor ?? CColors.lightOrange,
      );
    }
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onValueChanged,
      child: Container(
        width: 56.0,
        height: 52.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(width: 2.0, color: const Color(0xff3c984f)),
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Center(child: icon),
        ),
      ),
    );
  }
}
