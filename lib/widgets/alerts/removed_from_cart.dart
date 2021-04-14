import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/dialogs/alert_builder.dart';
import 'package:harvest/helpers/Localization/localization.dart';
class RemovedFromCart extends StatefulWidget {
  @override
  _RemovedFromCartState createState() => _RemovedFromCartState();
}

class _RemovedFromCartState extends State<RemovedFromCart> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: AlertBuilder(
        title: 'The Item Removed'.trs(context),
        subTitle: 'The item was removed from your cart'.trs(context),
        color: CColors.lightOrangeAccent,
        icon: SvgPicture.asset('assets/trash.svg'),
      ),
    );
  }
}
