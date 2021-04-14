import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';

///? Needs more work
//TODO: Fix the basket
class BasketStepper extends StatelessWidget {
  final int currentStep;
  final EdgeInsetsGeometry margin;
  const BasketStepper({
    Key key,
    this.currentStep = 0,
    this.margin = const EdgeInsets.only(top: 20),
  })  :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    int _step = currentStep;
    List<String> _titles = [
      "basket",
      "place",
      "delivery_time",
      "billing",
    ];
    List<String> _icons = [
      Constants.stepperBasketIcon,
      Constants.stepperPlaceIcon,
      Constants.stepperDeliveryTimeIcon,
      'assets/images/bank.svg',
    ];
    int _totalSteps = _titles.length;
    final size = MediaQuery.of(context).size;
    return Container(
      margin: margin,
      constraints: BoxConstraints(
        maxHeight: 35,
        maxWidth: size.width,
      ),
      child: Stack(
        clipBehavior: Clip.none, children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _totalSteps,
                (index) {
                  final _isLast = index == (_totalSteps) - 1;
                  final _isDotSelected = index <= _step;
                  final _isLineSelected = index <= _step - 1;
                  return _buildSection(
                    hideLine: _isLast,
                    isDotSelected: _isDotSelected,
                    isLineSelected: _isLineSelected,
                    steps: _totalSteps,
                    context: context,
                    stepTitle: _step == index ? "" : _titles[index].trs(context),
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _totalSteps,
                (index) {
                  final _isLast = index == (_totalSteps) - 1;
                  final _isNotFirst = index > 0;
                  final _isDotSelected = index <= _step;
                  final _isLineSelected = index <= _step - 1;
                  return _buildActiveSection(
                    title: _titles[index],
                    iconPath: _icons[index],
                    hideLine: _isLast,
                    isDotSelected: _isDotSelected,
                    isLineSelected: _isLineSelected,
                    steps: _totalSteps,
                    context: context,
                    isCurrentStep: _step == index,
                    switchFloatingCardDirection: _isNotFirst,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    bool hideLine = false,
    bool isDotSelected = false,
    bool isLineSelected = false,
    int steps = 0,
    BuildContext context,
    String stepTitle,
  }) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none, children: [
            Positioned(
              top: -23,
              left: (-(stepTitle.length * 22.0) / 5.0) / 2.0,
              child: Text(
                stepTitle,
                style: TextStyle(
                  fontSize: 13,
                  color: isDotSelected ? Colors.orange : Colors.grey,
                ),
              ),
            ),
            if (!isDotSelected) ...[
              _CircleAvatar(
                radius: 4.5,
                backgroundColor: CColors.fadeBlue,
              ),
            ] else ...[
              Stack(
                clipBehavior: Clip.none, children: [
                  _CircleAvatar(
                    radius: 4.5,
                    backgroundColor: CColors.darkOrange,
                  ),
                ],
              ),
            ],
          ],
        ),
        if (!hideLine)
          Container(
            width: (size.width * 0.95) / steps,
            height: 3,
            color: isLineSelected ? Colors.orange : CColors.fadeBlue,
          ),
      ],
    );
  }

  Widget _buildActiveSection({
    @required BuildContext context,
    @required String title,
    @required String iconPath,
    bool hideLine = false,
    bool isDotSelected = false,
    bool isLineSelected = false,
    int steps = 0,
    bool isCurrentStep = false,
    bool switchFloatingCardDirection = false,
  }) {
    final size = MediaQuery.of(context).size;
    final double _radius = 17;
    return Stack(
      clipBehavior: Clip.none, children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDotSelected && isCurrentStep) ...[
              _CircleAvatar(
                radius: _radius,
                backgroundColor: CColors.darkOrange.withOpacity(0.2),
                child: _CircleAvatar(
                  radius: _radius * 0.75,
                  backgroundColor: CColors.darkOrange,
                  child: SvgPicture.asset(
                    iconPath,
                    color: Colors.white,
                    width: _radius * 0.8,
                  ),
                ),
              ),
            ] else if (isDotSelected && !isCurrentStep) ...[
              _CircleAvatar(
                radius: 4.5,
                backgroundColor: CColors.transparent,
              ),
            ] else ...[
              _CircleAvatar(
                radius: 4.5,
                backgroundColor: Colors.transparent,
              ),
            ],
            if (!hideLine)
              Container(
                width: (size.width * 0.95) / steps,
                height: 3,
                // color: Colors.blue,
              ),
          ],
        ),
        if (isCurrentStep)
          PositionedDirectional(
            top: -_radius * 2,
            start: _radius,
            child: Card(
              color: CColors.darkOrange,
              elevation: 0.0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                  bottomEnd: Radius.circular(10),
                ),
              ),
              child: _floatingTitle(title, context),
            ),
          ),
        // if (isCurrentStep && switchFloatingCardDirection)
        //   PositionedDirectional(
        //     top: -_radius * 1.2,
        //     start: (-(title.length * 22.0) / 5.0) - _radius * 1.2,
        //     child: Center(
        //       child: Card(
        //         color: CColors.lightOrange,
        //         elevation: 0.0,
        //         margin: EdgeInsets.zero,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadiusDirectional.only(
        //             topEnd: Radius.circular(10),
        //             topStart: Radius.circular(10),
        //             bottomStart: Radius.circular(10),
        //           ),
        //         ),
        //         child: _floatingTitle(title, context),
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  Widget _floatingTitle(String text, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: text.length >= 8 ? 8 : 6, vertical: 5),
      child: Text(
        text.trs(context),
        style: TextStyle(color: CColors.white, fontSize: 12),
      ),
    );
  }
}

//? Animations was diabled in that version
class _CircleAvatar extends StatelessWidget {
  /// Creates a circle that represents a user.
  const _CircleAvatar({
    Key key,
    this.child,
    this.backgroundColor,
    this.backgroundImage,
    this.onBackgroundImageError,
    this.foregroundColor,
    this.radius,
    this.minRadius,
    this.maxRadius,
  })  : assert(radius == null || (minRadius == null && maxRadius == null)),
        assert(backgroundImage != null || onBackgroundImageError == null),
        super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget. If the [_CircleAvatar] is to have an image, use
  /// [backgroundImage] instead.
  final Widget child;

  /// The color with which to fill the circle. Changing the background
  /// color will cause the avatar to animate to the new color.
  ///
  /// If a [backgroundColor] is not specified, the theme's
  /// [ThemeData.primaryColorLight] is used with dark foreground colors, and
  /// [ThemeData.primaryColorDark] with light foreground colors.
  final Color backgroundColor;

  /// The default text color for text in the circle.
  ///
  /// Defaults to the primary text theme color if no [backgroundColor] is
  /// specified.
  ///
  /// Defaults to [ThemeData.primaryColorLight] for dark background colors, and
  /// [ThemeData.primaryColorDark] for light background colors.
  final Color foregroundColor;

  /// The background image of the circle. Changing the background
  /// image will cause the avatar to animate to the new image.
  ///
  /// If the [_CircleAvatar] is to have the user's initials, use [child] instead.
  final ImageProvider backgroundImage;

  /// An optional error callback for errors emitted when loading
  /// [backgroundImage].
  final ImageErrorListener onBackgroundImageError;

  /// The size of the avatar, expressed as the radius (half the diameter).
  ///
  /// If [radius] is specified, then neither [minRadius] nor [maxRadius] may be
  /// specified. Specifying [radius] is equivalent to specifying a [minRadius]
  /// and [maxRadius], both with the value of [radius].
  ///
  /// If neither [minRadius] nor [maxRadius] are specified, defaults to 20
  /// logical pixels. This is the appropriate size for use with
  /// [ListTile.leading].
  ///
  /// Changes to the [radius] are animated (including changing from an explicit
  /// [radius] to a [minRadius]/[maxRadius] pair or vice versa).
  final double radius;

  /// The minimum size of the avatar, expressed as the radius (half the
  /// diameter).
  ///
  /// If [minRadius] is specified, then [radius] must not also be specified.
  ///
  /// Defaults to zero.
  ///
  /// Constraint changes are animated, but size changes due to the environment
  /// itself changing are not. For example, changing the [minRadius] from 10 to
  /// 20 when the [_CircleAvatar] is in an unconstrained environment will cause
  /// the avatar to animate from a 20 pixel diameter to a 40 pixel diameter.
  /// However, if the [minRadius] is 40 and the [_CircleAvatar] has a parent
  /// [SizedBox] whose size changes instantaneously from 20 pixels to 40 pixels,
  /// the size will snap to 40 pixels instantly.
  final double minRadius;

  /// The maximum size of the avatar, expressed as the radius (half the
  /// diameter).
  ///
  /// If [maxRadius] is specified, then [radius] must not also be specified.
  ///
  /// Defaults to [double.infinity].
  ///
  /// Constraint changes are animated, but size changes due to the environment
  /// itself changing are not. For example, changing the [maxRadius] from 10 to
  /// 20 when the [_CircleAvatar] is in an unconstrained environment will cause
  /// the avatar to animate from a 20 pixel diameter to a 40 pixel diameter.
  /// However, if the [maxRadius] is 40 and the [_CircleAvatar] has a parent
  /// [SizedBox] whose size changes instantaneously from 20 pixels to 40 pixels,
  /// the size will snap to 40 pixels instantly.
  final double maxRadius;

  // The default radius if nothing is specified.
  static const double _defaultRadius = 20.0;

  // The default min if only the max is specified.
  static const double _defaultMinRadius = 0.0;

  // The default max if only the min is specified.
  static const double _defaultMaxRadius = double.infinity;

  double get _minDiameter {
    if (radius == null && minRadius == null && maxRadius == null) {
      return _defaultRadius * 2.0;
    }
    return 2.0 * (radius ?? minRadius ?? _defaultMinRadius);
  }

  double get _maxDiameter {
    if (radius == null && minRadius == null && maxRadius == null) {
      return _defaultRadius * 2.0;
    }
    return 2.0 * (radius ?? maxRadius ?? _defaultMaxRadius);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final ThemeData theme = Theme.of(context);
    TextStyle textStyle = theme.primaryTextTheme.subtitle1.copyWith(color: foregroundColor);
    Color effectiveBackgroundColor = backgroundColor;
    if (effectiveBackgroundColor == null) {
      switch (ThemeData.estimateBrightnessForColor(textStyle.color)) {
        case Brightness.dark:
          effectiveBackgroundColor = theme.primaryColorLight;
          break;
        case Brightness.light:
          effectiveBackgroundColor = theme.primaryColorDark;
          break;
      }
    } else if (foregroundColor == null) {
      switch (ThemeData.estimateBrightnessForColor(backgroundColor)) {
        case Brightness.dark:
          textStyle = textStyle.copyWith(color: theme.primaryColorLight);
          break;
        case Brightness.light:
          textStyle = textStyle.copyWith(color: theme.primaryColorDark);
          break;
      }
    }
    final double minDiameter = _minDiameter;
    final double maxDiameter = _maxDiameter;
    return Container(
      constraints: BoxConstraints(
        minHeight: minDiameter,
        minWidth: minDiameter,
        maxWidth: maxDiameter,
        maxHeight: maxDiameter,
      ),
      // duration: Duration.zero,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        image: backgroundImage != null
            ? DecorationImage(
                image: backgroundImage,
                onError: onBackgroundImageError,
                fit: BoxFit.cover,
              )
            : null,
        shape: BoxShape.circle,
      ),
      child: child == null
          ? null
          : Center(
              child: MediaQuery(
                // Need to ignore the ambient textScaleFactor here so that the
                // text doesn't escape the avatar when the textScaleFactor is large.
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: IconTheme(
                  data: theme.iconTheme.copyWith(color: textStyle.color),
                  child: DefaultTextStyle(
                    style: textStyle,
                    child: child,
                  ),
                ),
              ),
            ),
    );
  }
}

/*
          Positioned(
            left: 0,
            right: 0,
            top: -10,
            child: Container(
              // color: Colors.blue,
              // width: size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  _totalSteps,
                  (index) {
                    final _isDotSelected = index <= _step;
                    return Expanded(
                      child: Container(
                        color: Colors.teal,
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            _step == index ? "" : _titles[index].trs(context),
                            style: TextStyle(
                              fontSize: 13,
                              color: _isDotSelected ? Colors.orange : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          */
