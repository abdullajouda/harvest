import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/helpers/Localization/localization.dart';
class AddressListTile extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final String title;
  final TextStyle titleStyle;
  final String subTitle;
  final TextStyle subTitleStyle;
  final Color color;

  const AddressListTile({
    Key key,
    this.onTap,
    @required this.title,
    this.titleStyle,
    @required this.subTitle,
    this.subTitleStyle,
    this.color, this.onEdit,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AppTranslations trs = AppTranslations.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            child: _ListTile(
              leading: SvgPicture.asset(Constants.mapPin,color:color, width: 40, height: 40),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: CColors.headerText,
                ).merge(titleStyle),
              ),
              subtitle: Text(
                subTitle,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ).merge(subTitleStyle),
              ),
            ),
          ),
        ),
        Positioned.directional(
          textDirection: trs.textDirection,
          end: -10,
          top: -10,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(color: CColors.white, width: 3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Color color;
  final RoundedRectangleBorder shape;
  final EdgeInsetsGeometry contentPadding;
  const _ListTile({
    Key key,
    @required this.leading,
    @required this.title,
    @required this.subtitle,
    this.color,
    this.shape,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? CColors.lightOrange,
        borderRadius: shape?.borderRadius ?? BorderRadius.circular(15),
      ),
      child: Padding(
        padding: contentPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            leading,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                subtitle,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
