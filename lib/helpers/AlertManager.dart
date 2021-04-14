import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest/Helpers/colors.dart';

class AlertBody {
  final String title;
  final TextStyle titleTextStyle;
  final String message;
  final TextStyle messageTextStyle;
  final Widget icon;
  final Color bgColor;
  final Color fgColor;
  final BuildContext context;
  final EdgeInsetsGeometry margin;

  const AlertBody({
    @required this.context,
    @required this.title,
    @required this.message,
    @required this.icon,
    this.titleTextStyle,
    this.messageTextStyle,
    this.bgColor = CColors.lightOrangeAccent,
    this.fgColor = CColors.white,
    this.margin = const EdgeInsets.only(bottom: 10),
  });
}

class AlertManager {
  static showDropDown({@required AlertBody alertBody}) {
    assert(alertBody != null);
    // final context = Get.context;
    final size = MediaQuery.of(alertBody.context).size;
    return GetBar(
      messageText: _body(size, alertBody),
      // colorText: Colors.transparent,
      backgroundColor: Colors.white,
      barBlur: 30,
      snackStyle: SnackStyle.GROUNDED,
      overlayColor: Colors.white,
      duration: Duration(days: 1),
      boxShadows: [
        BoxShadow(
          offset: Offset(0, 15),
          color: Colors.black.withOpacity(0.08),
          spreadRadius: 0.0,
          blurRadius: 15,
        )
      ],
      // borderWidth: 1,
      // borderRaduisG: BorderRadius.vertical(bottom: Radius.circular(20)),
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
    );
    // return Get.snackbar<void>(

    // );
  }

  static Widget _body(Size size, AlertBody alertBody) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(15, 10, 0, 10)
              .add(alertBody.margin),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: alertBody.bgColor,
                foregroundColor: alertBody.fgColor,
                child: alertBody.icon,
              ),
              SizedBox(width: 15),
              SizedBox(
                width: size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            alertBody.title,
                            style: TextStyle(
                              color: CColors.headerText,
                              fontWeight: FontWeight.w500,
                            ).merge(alertBody.titleTextStyle),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            alertBody.message,
                            style: TextStyle(
                              color: CColors.normalText,
                              fontSize: 13,
                            ).merge(alertBody.messageTextStyle),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Card(
            margin: EdgeInsets.only(bottom: 5),
            shadowColor: Colors.transparent,
            color: Colors.grey[300],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: SizedBox(width: size.width * 0.12, height: 4),
          ),
        ),
      ],
    );
  }
}
