import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/directions.dart';


class ChooseTime extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Direction(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 148,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 3),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(9999.0, 9999.0)),
                              color: const Color(0xa3f88518),
                            ),
                            child: Center(
                                child: SvgPicture.asset(
                                    'assets/calender.svg')),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Text(
                                  'Choose delivery time/date'.trs(context),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xff3c4959),
                                    letterSpacing: 0.14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Container(
                                height: 35,
                                width: 82,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  color: CColors.darkOrange,
                                ),
                                child: Center(
                                  child: Text(
                                    'OK'.trs(context),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: 0,
                  //   right: 0,
                  //   child: GestureDetector(
                  //     onTap: () => Navigator.pop(context),
                  //     child: Container(
                  //       height: 24,
                  //       width: 24,
                  //       decoration: BoxDecoration(
                  //         borderRadius:
                  //         BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                  //         color: Colors.white60,
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: const Color(0x12000000),
                  //             offset: Offset(0, 2),
                  //             blurRadius: 8,
                  //           ),
                  //         ],
                  //       ),
                  //       child: Center(
                  //         child: SvgPicture.asset('assets/icons/cancel.svg'),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
