import 'package:flutter/material.dart';
import 'package:harvest/helpers/Localization/lang_provider.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:provider/provider.dart';

class MyBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LangProvider>(context);
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: CColors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          lang.getLocaleCode() == 'ar'
              ? Icons.chevron_right
              : Icons.chevron_left,
          textDirection: TextDirection.ltr,
          color: CColors.headerText,
        ),
      ),
    );
  }
}
