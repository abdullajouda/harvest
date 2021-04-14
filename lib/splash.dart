import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/models/user.dart';
import 'package:harvest/customer/views/root_screen.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/splash_screen.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customer/models/city.dart';
import 'customer/views/auth/login.dart';
import 'helpers/Localization/lang_provider.dart';
import 'helpers/custom_page_transition.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
    final fToken = await _firebaseMessaging.getToken();
    prefs.setString('fcm_token', fToken);
    prefs.setString('language', LangProvider().getLocaleCode());
    var _duration = new Duration(seconds: 2);
    return Timer(_duration, setLandingPage);
  }

  setLandingPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var op = Provider.of<UserFunctions>(context, listen: false);
    String token = prefs.getString('userToken');
    int loginCount = prefs.getInt('loginCount');
    if (token != null) {
      op.setUser(
        User(
          id: prefs.getInt('id'),
          name: prefs.getString('username'),
          mobile: prefs.getString('mobile'),
          email: prefs.getString('email'),
          cityId: prefs.getInt('cityId'),
          imageProfile: prefs.getString('avatar'),
        ),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RootScreen(),
          ));
    } else {
      if (loginCount == 1) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) {
            return Login();
          },
        ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SplashScreen(),
            ));
      }
    }
  }

  // Future getCities() async {
  //   var op = Provider.of<CityOperations>(context, listen: false);
  //   print('this is locale :'+LangProvider().getLocaleCode());
  //   var request = await get(ApiHelper.api + 'getCities', headers: {
  //     'Accept': 'application/json',
  //     'Accept-Language': LangProvider().getLocaleCode(),
  //   });
  //   var response = json.decode(request.body);
  //   var items = response['cities'];
  //   op.clearCity();
  //   print(op.items.values.toList());
  //   print('after');
  //   items.forEach((element) {
  //     City city = City.fromJson(element);
  //     op.addItem(city);
  //     print(city.name);
  //   });
  // }

  @override
  void initState() {
    startTime();
    // getCities().then((value) => );
    // ApiServices().getSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CColors.lightOrange,
      body: Container(
          height: size.height,
          width: size.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  top: 0,
                  child: Opacity(
                    opacity: 0.1,
                    child: Column(
                      children: [
                        SvgPicture.asset('assets/splash_background.svg'),
                        SvgPicture.asset('assets/splash_background.svg')
                      ],
                    ),
                  )),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/logo.svg'),
                  SizedBox(
                    height: 22,
                  ),
                  Text(
                    'Freshly Picked … to Doorstep',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color(0xfff88518),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ],
          )),
    );
  }
}
