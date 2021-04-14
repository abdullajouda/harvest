import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/Localization/localization.dart';
class OnExit extends StatefulWidget {
  final Widget child;

  OnExit({Key key, this.child}) : super(key: key);

  @override
  _OnExitState createState() => _OnExitState();
}

class _OnExitState extends State<OnExit> {
  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: 'PressAgainToExit'.trs(context),
          backgroundColor: CColors.darkGreen,
          textColor: Colors.white);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () => onWillPop(), child: widget.child);
  }
}
