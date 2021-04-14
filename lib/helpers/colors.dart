import 'package:flutter/material.dart';

class CColors {
  static const Color headerText = const Color(0xff3C4959);
  static const Color normalText = Color(0xff969DA5);
  static const Color brightLight = Color(0xffE3E7EB);
  static const Color fadeGreen = Color(0xffE4F0E6);
  static const Color lightGreenAccent = Color(0xff8DDF33);
  static const Color lightGreen = Color(0xff3C984F);
  static const Color darkGreen = Color(0xff1F7F59);
  static const Color fadeOrange = Color(0xffFFF7EF);
  static const Color lightOrangeAccent = Color(0xffFAAA0B);
  static const Color darkOrange = Color(0xffF88518);
  static const Color lightOrange = Color(0xffFFF7EF);
  static const Color darkGrey = Color(0xff3C4959);
  static const Color darkGreyAccent = Color(0xffcccccc);
  static const Color grey = Color(0xff888A8D);
  static const Color skyBlue = Color(0xff9dc1eb);
  static const Color lightGrey = Color(0xffE9E9E9);
  static const Color lightBlue = Color(0xffEAF4FF);
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color bloodRed = Color(0xFFFF0000);
  static const Color coldBloodRed = Color(0xFFDC3130);
  static const Color coldPaleBloodRed = Color(0xFFD85656);
  static const Color lightBlack = Color(0xFFABABAB);
  static const Color boldBlackAccent = Color(0xFF606060);
  static const Color boldBlack = Color(0xFF302F2F);
  static const Color fadeBlue = Color(0xFFE4F0E6);
  static const Color fadeBlueAccent = Color(0xFFD0E6D7);
  static const Color fadeBeige = Color(0xfff6f6f6);

  static LinearGradient greenAppBarGradient({
    AlignmentGeometry begin = Alignment.centerRight,
    AlignmentGeometry end = Alignment.centerLeft,
    GradientTransform transform,
    TileMode tileMode = TileMode.clamp,
  }) {
    return LinearGradient(
      colors: [lightGreenAccent, darkGreen],
      begin: begin,
      end: end,
      transform: transform,
      tileMode: tileMode,

      // colors: [lightGreenAccent, darkGreen],
      // begin: begin,
      // end: end,
      // transform: transform,
      // tileMode: tileMode,
    );
  }




  static LinearGradient blackAppBarGradient({
    AlignmentGeometry begin = Alignment.centerRight,
    AlignmentGeometry end = Alignment.centerLeft,
    GradientTransform transform,
    TileMode tileMode = TileMode.clamp,
  }) {
    return LinearGradient(
      colors: [lightBlack, boldBlack],
      begin: begin,
      end: end,
      transform: transform,
      tileMode: tileMode,
    );
  }



  static LinearGradient blueAppBarGradient({
    AlignmentGeometry begin = Alignment.centerRight,
    AlignmentGeometry end = Alignment.centerLeft,
    GradientTransform transform,
    TileMode tileMode = TileMode.clamp,
  }) {
    return LinearGradient(
      colors: [const Color(0xff9dc1eb),const Color(0xff3a75bb)],
      begin: begin,
      end: end,
      transform: transform,
      tileMode: tileMode,
    );
  }


  static LinearGradient gradientGenerator({
    AlignmentGeometry begin = Alignment.centerRight,
    AlignmentGeometry end = Alignment.centerLeft,
    GradientTransform transform,
    TileMode tileMode = TileMode.clamp,
    Color color1,
    Color color2,
  }) {
    return LinearGradient(
      colors: [color1,color2],
      begin: begin,
      end: end,
      transform: transform,
      tileMode: tileMode,
    );
  }

  static LinearGradient walletGradient({
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
    GradientTransform transform,
    TileMode tileMode = TileMode.clamp,
  }) {
    return LinearGradient(
      colors: [Color(0xff8de290), Color(0xff2d895a)],
      begin: begin,
      end: end,
      transform: transform,
      tileMode: tileMode,
    );
  }
}
