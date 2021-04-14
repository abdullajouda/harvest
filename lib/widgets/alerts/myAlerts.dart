import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/constants.dart';

class MyAlert {
  static addedToCart(int type, context) {
    if (type == 0) {
      return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: CColors.white,
        borderRadius: 15,
        // boxShadows: [
        //   BoxShadow(
        //       color: Colors.black45, offset: Offset(0.0, 2.0), blurRadius: 3.0)
        // ],
        icon: Center(
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
              color: CColors.lightGreen,
            ),
            child: Center(
              child: Icon(
                Icons.check,
                color: CColors.white,
                size: 25,
              ),
            ),
          ),
        ),
        // backgroundColor: CColors.white,
        titleText: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'Added Successfully To Cart'.trs(context),
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xff3c4959),
              letterSpacing: 0.14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        messageText: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'You can find it in your cart  screen'.trs(context),
            style: TextStyle(
              fontSize: 13,
              color: const Color(0x66423959),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // content: AddedToCartAlert(),
        duration: Duration(seconds: 1),
      ).show(context);
    }
    else if(type == 1) {
      return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: CColors.white,
        borderRadius: 15,
        // boxShadows: [
        //   BoxShadow(
        //       color: Colors.black26, offset: Offset(0.0, 1.0), blurRadius: 1.0)
        // ],
        icon: Center(
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
              color: CColors.lightOrangeAccent,
            ),
            child: Center(
              child: SvgPicture.asset('assets/trash.svg'),
            ),
          ),
        ),
        // backgroundColor: CColors.white,
        titleText: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'The Item Removed'.trs(context),
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xff3c4959),
              letterSpacing: 0.14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        messageText: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'The item was removed from your cart'.trs(context),
            style: TextStyle(
              fontSize: 13,
              color: const Color(0x66423959),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // content: AddedToCartAlert(),
        duration: Duration(seconds: 1),
      ).show(context);
    }
    else if(type == 2){
      return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: CColors.white,
        borderRadius: 15,
        // boxShadows: [
        //   BoxShadow(
        //       color: Colors.black45, offset: Offset(0.0, 2.0), blurRadius: 3.0)
        // ],
        icon: Center(
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
              color: CColors.lightOrangeAccent,
            ),
            child: Center(
              child: SvgPicture.asset(Constants.mapPinIcon,color: CColors.white,),
            ),
          ),
        ),
        // backgroundColor: CColors.white,
        titleText: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'Address set to default'.trs(context),
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xff3c4959),
              letterSpacing: 0.14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        messageText: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'Address set as the default address'.trs(context),
            style: TextStyle(
              fontSize: 13,
              color: const Color(0x66423959),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // content: AddedToCartAlert(),
        duration: Duration(seconds: 1),
      ).show(context);
    }
  }
}
