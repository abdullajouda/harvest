import 'package:flutter/material.dart';
import 'package:harvest/helpers/Localization/lang_provider.dart';

class Direction extends StatelessWidget {
  final Widget child;

  const Direction({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: LangProvider().getLocaleCode() == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: child);
  }
}
