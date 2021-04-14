import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/directions.dart';

class RemoveIconDecoration {
  final double raduis;
  final double iconSize;
  final Color iconColor;
  final Color backgroundColor;
  final double borderWidth;
  final Color borderColor;
  final double elevation;

  const RemoveIconDecoration({
    this.raduis = 3,
    this.iconSize = 14,
    this.iconColor = CColors.headerText,
    this.backgroundColor = CColors.fadeBlue,
    this.borderColor = CColors.white,
    this.borderWidth = 3,
    this.elevation,
  });

  static merge() {}

  static RemoveIconDecoration copyWith({
    double raduis,
    double iconSize,
    Color iconColor,
    Color backgroundColor,
    double borderWidth,
    Color borderColor,
    double elevation,
  }) {
    const RemoveIconDecoration decoration = const RemoveIconDecoration();
    return RemoveIconDecoration(
      raduis: raduis ?? decoration.raduis,
      iconSize: iconSize ?? decoration.iconSize,
      iconColor: iconColor ?? decoration.iconColor,
      backgroundColor: backgroundColor ?? decoration.backgroundColor,
      borderWidth: borderWidth ?? decoration.borderWidth,
      borderColor: borderColor ?? decoration.borderColor,
      elevation: elevation ?? decoration.elevation,
    );
  }
}

class RemoveIcon extends StatelessWidget {
  final VoidCallback onTap;
  final RemoveIconDecoration deocation;
  final bool enabled;
  final Widget child;
  final Alignment iconAlignment;
  final List<BoxShadow> shadow;

  const RemoveIcon({
    Key key,
    this.onTap,
    this.deocation = const RemoveIconDecoration(),
    this.enabled = true,
    this.child,
    this.iconAlignment = Alignment.bottomRight,
    this.shadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Direction(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          PositionedDirectional(
            end: -10,
            bottom: iconAlignment.y == 1.0 ? -10 : null,
            top: iconAlignment.y == 1.0 ? null : -10,
            child: GestureDetector(
              onTap: onTap,
              child: Material(
                elevation: deocation.elevation ?? 0.0,
                color: CColors.transparent,
                type: MaterialType.circle,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: deocation.backgroundColor,
                    border: Border.all(
                        color: deocation.borderColor,
                        width: deocation.borderWidth),
                    boxShadow: deocation.elevation == null ? null : shadow,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(deocation.raduis),
                    child: Icon(
                      Icons.close,
                      color: deocation.iconColor,
                      size: deocation.iconSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
