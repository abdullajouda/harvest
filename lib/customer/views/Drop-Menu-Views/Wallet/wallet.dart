import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/customer/views/Basket/basket.dart';
import 'package:harvest/customer/views/webview.dart';
import 'package:harvest/customer/widgets/custom_main_button.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:harvest/widgets/backButton.dart';
import 'package:harvest/widgets/basket_button.dart';
import 'package:harvest/widgets/dialogs/alert_builder.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'wallet_amount_viewer.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/home_popUp_menu.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  TextEditingController _controller;
  bool load = false;
  bool loadConvert = false;
  String balance;
  String points;
  int _selectedIndex = -1;

  getWallet() async {
    setState(() {
      load = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await get(ApiHelper.api + 'getWallet', headers: {
      'Accept': 'application/json',
      'Accept-Language': '${prefs.getString('language')}',
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    setState(() {
      balance = response['balance'];
      points = double.parse(response['points'].toString()).toStringAsFixed(3);
      load = false;
    });
  }

  addAmount() async {
    setState(() {
      load = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await post(ApiHelper.api + 'addBalanceToWallet', body: {
      'balance': '${_controller.text}',
    }, headers: {
      'Accept': 'application/json',
      'Accept-Language': '${prefs.getString('language')}',
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    print(response);
    if (response['payment_link'] != '') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewExample(
              url: response['payment_link'].toString(),
              path: 'wallet',
            ),
          ));
    } else {
      Navigator.of(context, rootNavigator: true)
          .pushReplacement(MaterialPageRoute(
        builder: (context) => Wallet(),
      ));
    }
    // getWallet();
    setState(() {
      load = false;
    });
  }

  convertPoints() async {
    setState(() {
      loadConvert = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await post(ApiHelper.api + 'convertPointsToWallet', headers: {
      'Accept': 'application/json',
      'Accept-Language': '${prefs.getString('language')}',
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    if (response['code'] == 203) {
      showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.1),
        transitionDuration: Duration(milliseconds: 500),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return GestureDetector(
            onTap: () => Navigator.pop(context),
            child: AlertBuilder(
              title: 'NOT ENOUGH POINTS'.trs(context),
              subTitle: response['message'],
              color: CColors.lightOrangeAccent,
              icon: Icon(
                Icons.warning_amber_rounded,
                color: CColors.white,
                size: 25,
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position:
                Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
    } else if (response['code'] == 200) {
      getWallet();
    }
    setState(() {
      loadConvert = false;
      load = false;
    });
  }

  @override
  void initState() {
    _controller = TextEditingController();
    getWallet();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: LangProvider().getLocaleCode() == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: WaveAppBar(
          // hideActions: true,
          backgroundGradient: CColors.greenAppBarGradient(),
          bottomViewOffset: Offset(0, -10),
          actions: [HomePopUpMenu()],
          leading: MyBackButton(),
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 25),
            children: [
              Text(
                "wallet".trs(context),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: CColors.headerText,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              WalletAmount(
                  load: load, amount: balance, margin: EdgeInsets.zero),
              SizedBox(height: 20),
              _buildConvertPointsToWallet(context),
              SizedBox(height: size.height * 0.06),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "charge_wallet_from_card".trs(context),
                    style: TextStyle(
                      color: CColors.lightGreen,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 15, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "select_the_amount".trs(context),
                          style: TextStyle(
                            color: CColors.normalText,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.09,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 3,
                                child: ListView.separated(
                                  itemCount: 4,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final _isSelected = _selectedIndex == index;
                                    final _textColor = _isSelected
                                        ? CColors.white
                                        : CColors.lightGreen;
                                    final _backgroundColor = !_isSelected
                                        ? CColors.white
                                        : CColors.lightGreen;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() => _selectedIndex = index);
                                        FocusScope.of(context).unfocus();
                                        setState(() {
                                          _controller = TextEditingController(
                                              text: '${50 * (index + 1)}');
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: _backgroundColor,
                                          border: Border.all(
                                              color: CColors.lightGreen,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${50 * (index + 1)}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: _textColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "usd".trs(context),
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: _textColor,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Text(
                                        "another_amount".trs(context),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: CColors.lightGreen,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      controller: _controller,
                                      style: TextStyle(fontSize: 12),
                                      onTap: () {
                                        setState(() => _selectedIndex = -1);
                                      },
                                      decoration: InputDecoration(
                                        prefix: Text(
                                          '${'Q.R'.trs(context)}',
                                          style: TextStyle(
                                            fontSize: 8,
                                            color: const Color(0x993c984f),
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsetsDirectional.only(
                                                start: 10, top: 9, bottom: 9),
                                        hintStyle: TextStyle(fontSize: 12),
                                        border: _buildVoucherTextFieldBorder(),
                                        focusedBorder:
                                            _buildVoucherTextFieldBorder(),
                                        enabledBorder:
                                            _buildVoucherTextFieldBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 17,
                        width: 17,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: const Color(0x0d2c2c2c),
                        ),
                        child: Center(
                          child: Container(
                            height: 7,
                            width: 7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              color: const Color(0xff3c984f),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        child: Text(
                          "add_from_your_card".trs(context),
                          style: TextStyle(
                            color: CColors.lightGreen,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Container(
                  //   margin: EdgeInsetsDirectional.only(start: 15),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10.0),
                  //     color: const Color(0xffffffff),
                  //     border:
                  //         Border.all(width: 2.0, color: const Color(0xffffeede)),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: const Color(0x14535353),
                  //         offset: Offset(0, 5),
                  //         blurRadius: 7,
                  //       ),
                  //     ],
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 20, vertical: 15),
                  //     child: Row(
                  //       children: [
                  //         SvgPicture.asset(
                  //           'assets/icons/credit-card.svg',
                  //           color: CColors.darkOrange,
                  //         ),
                  //         SizedBox(width: 10),
                  //         Text(
                  //           "card".trs(context),
                  //           style: TextStyle(
                  //             color: CColors.darkOrange,
                  //             fontSize: 15,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: 120),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: MainButton(
                  onTap: () {
                    addAmount();
                  },
                  title: 'Charge'.trs(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConvertPointsToWallet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CColors.fadeOrange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              period: Duration(milliseconds: 200),
              enabled: load,
              baseColor: load ? Colors.white : CColors.darkOrange,
              highlightColor: CColors.darkOrange,
              child: Text.rich(
                TextSpan(
                  text: "${points ?? 0}",
                  style: TextStyle(
                    color: CColors.darkOrange,
                    fontWeight: FontWeight.w500,
                    fontSize: 19,
                  ),
                  children: [
                    TextSpan(
                      text: "\t" + "points".trs(context),
                      style: TextStyle(
                        color: CColors.darkOrange,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FlatButton.icon(
              color: CColors.darkOrange,
              // padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onPressed: () {
                convertPoints();
              },
              icon: loadConvert
                  ? SpinKitFadingCircle(
                      color: CColors.white,
                      size: 14,
                    )
                  : SvgPicture.asset(Constants.moneyExchange, width: 14),
              label: Text(
                "convert_to_wallet".trs(context),
                style: TextStyle(
                  color: CColors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ShapeBorder _buildVoucherTextFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Color(0x0ff3C984F), width: 1),
    );
  }
}
