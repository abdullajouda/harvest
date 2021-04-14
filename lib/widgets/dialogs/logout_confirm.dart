import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/favorite.dart';
import 'package:harvest/customer/models/notifications.dart';
import 'package:harvest/customer/models/user.dart';
import 'package:harvest/helpers/Localization/lang_provider.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/directions.dart';
import 'package:harvest/main.dart';
import 'package:harvest/splash.dart';
import 'package:harvest/splash_screen.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmDialog extends StatefulWidget {
  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  bool load = false;

  signOut() async {
    setState(() {
      load = true;
    });
    var op = Provider.of<FavoriteOperations>(context, listen: false);
    var no = Provider.of<NotificationOperations>(context, listen: false);
    var us = Provider.of<UserFunctions>(context, listen: false);
    var ca = Provider.of<Cart>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await get(ApiHelper.api + 'logout', headers: {
      'Accept': 'application/json',
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    // Fluttertoast.showToast(msg: response['message']);
    op.clearFav();
    op.clearHome();
    no.clearNotes();
    us.clearUser();
    ca.clearFav();
    prefs.remove('userToken');
    prefs.remove('fcm_token');
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(
      builder: (context) => MyApp(),
    ));
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Direction(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 154,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 146,
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
                                  'assets/icons/alert-triangle.svg')),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Logout, Are You Sure?'.trs(context),
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xff3c4959),
                              letterSpacing: 0.14,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 35,
                                width: 84,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  border: Border.all(color: CColors.darkOrange),
                                ),
                                child: Center(
                                    child: Text(
                                  'No'.trs(context),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: CColors.darkOrange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.left,
                                )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () => signOut(),
                              child: Container(
                                height: 35,
                                width: 84,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  color: CColors.darkOrange,
                                ),
                                child: Center(
                                  child: load
                                      ? SpinKitFadingFour(
                                          color: CColors.white,
                                          size: 12,
                                        )
                                      : Text(
                                          'Yes'.trs(context),
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                        color: Colors.white60,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x12000000),
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset('assets/icons/cancel.svg'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
