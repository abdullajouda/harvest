import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/terms.dart';
import 'package:harvest/customer/views/auth/activate_account.dart';
import 'package:harvest/customer/views/auth/login2.dart';
import 'package:harvest/customer/views/root_screen.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:harvest/main.dart';
import 'package:harvest/widgets/button_loader.dart';
import 'package:harvest/widgets/directions.dart';
import 'package:harvest/widgets/language_picker.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harvest/helpers/Localization/localization.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool load = false;
  String mobile;
  int group = 0 ;

  signIn() async {
    setState(() {
      load = true;
    });
    if (_formKey.currentState.validate()) {
      final lang = Provider.of<LangProvider>(context,listen: false);
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      var request = await post(ApiHelper.api + 'sendLoginCode', body: {
        'mobile': mobile
      }, headers: {
        'Accept': 'application/json',
        'Accept-Language': LangProvider().getLocaleCode(),
      });
      var response = json.decode(request.body);
      if (response['status'] == true) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AccountActivation(
                mobile: mobile,
              ),
            ));
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

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LangProvider>(context);
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
                        'Log In'.trs(context),
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
                                width: 15.0, color: const Color(0xfffec896)),
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
                        SvgPicture.asset('assets/images/Market.svg'),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: LanguagePicker(
                            onChanged: (value) {
                              if (value.languageCode != lang.getLocaleCode()) {
                                if (value.languageCode == 'en') {
                                  lang.setLocale(locale: Locales.en);
                                } else if (value.languageCode == 'ar') {
                                  lang.setLocale(locale: Locales.ar);
                                }
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => MyApp(),
                                    ));
                              }
                            },
                            value: Locale(lang.getLocaleCode()),
                          ),
                        )),
                    Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 15, top: 41),
                                child: Form(
                                  key: _formKey,
                                  child: Container(
                                    width: 260,
                                    child: Center(
                                      child: TextFormField(
                                          onChanged: (newValue) {
                                            setState(() {
                                              mobile = newValue;
                                            });
                                          },
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "* Required".trs(context);
                                            } else
                                              return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: inputDecorationWithIcon(
                                            'phoneNumber'.trs(context),
                                            SvgPicture.asset(
                                                'assets/icons/mobile.svg'),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => signIn(),
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
                                            'continue'.trs(context),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: const Color(0xffffffff),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 28, bottom: 50),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Theme(
                                        data: ThemeData(
                                            unselectedWidgetColor:
                                                Colors.grey[300]),
                                        child: Radio<int>(
                                          value: 0,
                                          groupValue: group,
                                          activeColor: CColors.darkGreen,
                                          onChanged: (value) {},
                                        ),
                                      ),
                                      Text(
                                        'By Continuing you agree to our'
                                            .trs(context),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: const Color(0xff888a8d),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Terms(
                                                  path: 'this',
                                                ),
                                              ));
                                        },
                                        child: Text(
                                          'terms'.trs(context),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: const Color(0xff3c984f),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RootScreen(),
                                          ));
                                    },
                                    child: Text(
                                      'skip'.trs(context),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: const Color(0xfffdaa5c),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
