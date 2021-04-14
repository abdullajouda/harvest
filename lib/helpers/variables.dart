import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:intl/intl.dart';

import 'package:harvest/helpers/Localization/localization.dart';

const String appName = 'Harvest';
const String appStoreId = 'com.example.harvest';

const kPrimaryColor = CColors.darkOrange;
const kSecondaryColor = Color(0xffc99200);
const kDarkPrimaryColor = Color(0xffecb7bf);
const kFontRoboto = 'Roboto';
const kFontNeoSans = 'NeoSans';



// String translateText(BuildContext context, String key) {
//   return AppLocalization.of(context).translate(key);
// }

//getLang()async{
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  return prefs.getString('language');
//}

class FieldValidator {
  static String validate(String value, context) {
    if (value.isEmpty) {
      return  '* Required'.trs(context);
    }
    return null;
  }
}

InputDecoration searchDecoration(hint, icon) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      fontSize: 16,
      color: const Color(0xffe3e3e3),
      letterSpacing: -0.256,
      height: 1.25,
    ),
    prefixIcon: icon,
    border: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
  );
}



InputDecoration locationFieldDecoration(hint) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(left: 15,right: 15,top: 15),
    hintText: hint,
    errorStyle: TextStyle(
      fontSize: 8,
      color: CColors.coldPaleBloodRed,
    ),
    hintStyle: TextStyle(
      fontSize: 8,
      color: const Color(0xff525768),
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12.0),
        borderSide: BorderSide( width: 1.0,
            color: const Color(0xffe3e7eb))
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12.0),
        borderSide: BorderSide( width: 1.0,
            color: const Color(0xffe3e7eb))
    ),
    border: OutlineInputBorder(
      borderRadius:
      BorderRadius.circular(12.0),
      borderSide: BorderSide( width: 1.0,
          color: const Color(0xffe3e7eb))
    ),
  );
}

InputDecoration inputDecoration(hint) {
  return InputDecoration(
    filled: true,
    contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 17),
    hintText: hint,
    fillColor: CColors.fadeBlue,
    hintStyle: TextStyle(
        color: CColors.grey, fontWeight: FontWeight.w400, fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(width: 2.0, color: const Color(0xccd85656)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(width: 2.0, color: const Color(0xccd85656)),
    ),
  );
}

InputDecoration inputDecorationWithIcon(hint, icon) {
  return InputDecoration(
    filled: true,
    fillColor: CColors.fadeBlue,
    prefixIcon: Container(
        width: 20,
        child: Center(
          child: icon,
        )),
    contentPadding: EdgeInsets.symmetric(vertical: 20),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(width: 2.0, color: const Color(0xccd85656)),
    ),
    hintText: hint,
    hintStyle: TextStyle(
        color: CColors.grey, fontWeight: FontWeight.w400, fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(width: 2.0, color: const Color(0xccd85656)),
    ),
  );
}

InputDecoration fatInputDecoration(title) {
  return InputDecoration(
    contentPadding: new EdgeInsets.only(top: 5.0, left: 10.0, right: 10),
    hintStyle: TextStyle(
      fontSize: 16,
      color: const Color(0xff717171),
    ),
    hintText: title,
    border: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
  );
}

InputDecoration hintInputDecoration(title) {
  return InputDecoration(
    contentPadding: new EdgeInsets.symmetric(horizontal: 10.0),
    hintStyle: TextStyle(
      fontSize: 16,
      color: const Color(0xff717171),
    ),
    hintText: title,
    border: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
  );
}
