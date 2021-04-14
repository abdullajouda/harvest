import 'package:flutter/material.dart';
import 'package:harvest/customer/widgets/custom_main_button.dart';

import 'package:harvest/helpers/Localization/localization.dart';

class BasketPagesControlles extends StatelessWidget {
  final bool enabled;
  final bool enableContinue;
  final bool enablePrev;
  final VoidCallback onContinuePressed;
  final VoidCallback onPrevPressed;
  final String continueText;
  final String prevText;
  const BasketPagesControlles({
    Key key,
    this.enabled = true,
    this.enableContinue = true,
    this.enablePrev = true,
    this.onContinuePressed,
    this.onPrevPressed,
    this.continueText,
    this.prevText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "const _DefaultControllesHeroTag()",
      child: Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Row(
          children: [
            Expanded(
              child: MainButton(
                enabled: enabled && enablePrev,
                onTap: onPrevPressed,
                constraints: BoxConstraints(),
                titlePadding: EdgeInsets.all(8),
                title: prevText ?? "previous".trs(context),
                outLined: true,
                titleTextStyle: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: MainButton(
                enabled: enabled && enableContinue,
                onTap: onContinuePressed,
                constraints: BoxConstraints(),
                titlePadding: EdgeInsets.all(10),
                title: continueText ?? "continue".trs(context),
                titleTextStyle: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
