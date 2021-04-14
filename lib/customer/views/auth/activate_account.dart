import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:harvest/customer/models/delivery-data.dart';
import 'package:harvest/helpers/Localization/localization.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/models/user.dart';
import 'package:harvest/customer/views/auth/login2.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:harvest/helpers/services.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:harvest/widgets/button_loader.dart';
import 'package:harvest/widgets/countdown.dart';
import 'package:harvest/widgets/directions.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../root_screen.dart';
import 'login.dart';

class AccountActivation extends StatefulWidget {
  final String mobile;

  const AccountActivation({Key key, this.mobile}) : super(key: key);

  @override
  _AccountActivationState createState() => _AccountActivationState();
}

class _AccountActivationState extends State<AccountActivation>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AnimationController _controller;
  Timer _timer;
  int _start = 120;
  bool load = false;
  bool loadResend = false;
  String code;
  String deviceType;

  void startTimer() async {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  sendCode() async {
    if (Platform.isIOS) {
      deviceType = "ios";
    } else {
      deviceType = 'android';
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      load = true;
    });
    if (_formKey.currentState.validate()) {
      String fToken = prefs.getString('fcm_token');
      var request = await post(ApiHelper.api + 'verifyCode', body: {
        'code': code,
        'mobile': widget.mobile,
        'device_type': deviceType,
        'fcm_token': fToken
      }, headers: {
        'Accept': 'application/json',
        'Accept-Language': LangProvider().getLocaleCode(),
      });
      var response = json.decode(request.body);
      if (response['code'] == 200) {
        if (response['user'] != null) {
          User user = User.fromJson(response['user']);
          DeliveryAddresses addresses = DeliveryAddresses.fromJson(
              response['user']['delivery_addresses'][0]);
          Services().setToken(response['user']['access_token']);
          Services().setUser(
              response['user']['id'],
              response['user']['city_id'],
              response['user']['name'],
              response['user']['email'],
              response['user']['mobile'],
              response['user']['image_profile']);
          Services().setDefaultAddress(addresses.id,
              address: addresses.address,
              buildingNumber: addresses.buildingNumber,
              city: addresses.city.name,
              deliveryCost: addresses.city.deliveryCost,
              lat: addresses.lat,
              lng: addresses.lan,
              minOrder: addresses.city.minOrder,
              unitNumber: addresses.unitNumber);
          prefs.setInt('loginCount', 1);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RootScreen(),
              ));
        }

        // Navigator.push(
        //     context,
        //     CustomPageRoute(
        //       builder: (context) => Login2(),
        //     ));
      } else if (response['code'] == 203) {
        Navigator.pushReplacement(
            context,
          MaterialPageRoute(
              builder: (context) => Login2(
                mobile: widget.mobile,
              ),
            ),);
      } else {
        Fluttertoast.showToast(msg: response['message']);
        setState(() {
          load = false;
        });
      }
    }
    setState(() {
      load = false;
    });
  }

  resendCode() async {
    setState(() {
      loadResend = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await post(ApiHelper.api + 'reSendCode', headers: {
      'Accept': 'application/json',
      'Accept-Language': LangProvider().getLocaleCode(),
    }, body: {
      'mobile': widget.mobile
    });

    var res = json.decode(response.body);
    if (res['status'] == true) {
      setState(() {
        loadResend = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AccountActivation(
            mobile: widget.mobile,
          ),
        ),
      );
    }
    Fluttertoast.showToast(msg: res['message']);
    setState(() {
      loadResend = false;
    });
  }

  @override
  void initState() {
    startTimer();
    _controller =
        AnimationController(duration: Duration(minutes: 2));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Direction(
      child: Scaffold(
        backgroundColor: Color(0x0ffE6F2EA),
        body: Container(
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset('assets/Dots.svg'),
              Positioned(
                top: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Text(
                        'account_activation'.trs(context),
                        style: TextStyle(
                          fontSize: 22,
                          color: const Color(0xff3c4959),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 230.0,
                          height: 230.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.elliptical(9999.0, 9999.0)),
                            border: Border.all(
                                width: 15.0, color: const Color(0xffAAE1AC)),
                          ),
                        ),
                        Container(
                          height: 150,
                          width: 150,
                          child: SvgPicture.string(
                            '<svg viewBox="0.0 0.0 165.2 165.2" ><defs><filter id="shadow"><feDropShadow dx="0" dy="36" stdDeviation="24"/></filter></defs><path transform="translate(0.0, 0.0)" d="M 82.6219482421875 0 C 128.2527923583984 0 165.243896484375 36.99110794067383 165.243896484375 82.6219482421875 C 165.243896484375 128.2527923583984 128.2527923583984 165.243896484375 82.6219482421875 165.243896484375 C 36.99110794067383 165.243896484375 0 128.2527923583984 0 82.6219482421875 C 0 36.99110794067383 36.99110794067383 0 82.6219482421875 0 Z" fill="#f7fcf9" stroke="#ffffff" stroke-width="7.700000286102295" stroke-miterlimit="4" stroke-linecap="butt" filter="url(#shadow)"/></svg>',
                            allowDrawingOutsideViewBox: true,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                            height: 150,
                            child: Center(
                                child: SvgPicture.asset(
                                    'assets/images/strawberry.svg'))),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(33.0),
                      topRight: Radius.circular(33.0),
                    ),
                    color: const Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x1a000000),
                        offset: Offset(0, -5),
                        blurRadius: 51,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Container(
                              height: 33,
                              width: _start != 0 ? 60 : 120,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11.0),
                                color: const Color(0xffebf4ee),
                              ),
                              child: Center(
                                child: _start != 0
                                    ? Countdown(
                                        animation: StepTween(
                                          begin: 2 * 60,
                                          end: 0,
                                        ).animate(_controller),
                                      )
                                    : FlatButton(
                                        onPressed: () => resendCode(),
                                        child: loadResend
                                            ? LoadingBtn()
                                            : Text(
                                                "Resend code".trs(context),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: const Color(0xccf88518),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                      ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Form(
                              key: _formKey,
                              child: Container(
                                width: 260,
                                child: Center(
                                  child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (newValue) {
                                        setState(() {
                                          code = newValue;
                                        });
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "* Required".trs(context);
                                        } else
                                          return null;
                                      },
                                      decoration: inputDecoration(
                                          'activation_code'.trs(context))),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => sendCode(),
                            child: Container(
                              height: 60,
                              width: 260,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: const Color(0x0ff3C984F),
                              ),
                              child: Center(
                                child: load
                                    ? LoadingBtn()
                                    : Text(
                                        'activate'.trs(context),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: const Color(0xffffffff),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 15),
                            child: TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  )),
                              child: Text(
                                'return'.trs(context),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xfffdaa5c),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
