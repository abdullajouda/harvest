import 'package:flutter/material.dart';
import 'package:harvest/helpers/Localization/lang_provider.dart';
import 'package:harvest/helpers/colors.dart';

class CIconButton extends StatelessWidget {
  final Widget icon;
  final EdgeInsetsGeometry contentPadding;
  final Color color;
  final VoidCallback onTap;

  const CIconButton({
    Key key,
    this.icon,
    this.contentPadding,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: color ?? CColors.brightLight,
        child: Padding(
          padding: contentPadding ?? const EdgeInsets.all(2.0),
          child: icon,
        ),
      ),
    );
  }
}

class CBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const CBackButton({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        } else {
          Navigator.maybePop(context);
        }
      },
      child: Container(
        margin: EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxHeight: 25,
          maxWidth: 25,
        ),
        decoration: BoxDecoration(
          color: CColors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          LangProvider().getLocaleCode() == 'ar'
              ? Icons.chevron_right
              : Icons.chevron_left,
          textDirection: TextDirection.ltr,
          color: CColors.headerText,
        ),
      ),
    );
  }
}
