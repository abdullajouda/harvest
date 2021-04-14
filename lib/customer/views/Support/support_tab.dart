import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/components/WaveAppBar/appBar_body.dart';
import 'package:harvest/customer/views/Basket/basket.dart';
import 'package:harvest/customer/views/Support/support_chat.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/widgets/Loader.dart';
import 'package:harvest/widgets/basket_button.dart';
import 'package:harvest/widgets/home_popUp_menu.dart';
import 'package:harvest/widgets/not_authenticated.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportTab extends StatefulWidget {
  SupportTab({Key key}) : super(key: key);

  @override
  _SupportTabState createState() => _SupportTabState();
}

class _SupportTabState extends State<SupportTab> {
  TextEditingController _textEditingController;
  bool isAuthenticated = false;
  bool load = false;

  sendMessage() async {
    if(_textEditingController.text != ''){
      setState(() {
        load = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var request = await post(ApiHelper.api + 'contactUs', body: {
        'message': _textEditingController.text
      }, headers: {
        'Accept': 'application/json',
        'Accept-Language': LangProvider().getLocaleCode(),
        'Authorization': 'Bearer ${prefs.getString('userToken')}'
      });
      var res = json.decode(request.body);
      Fluttertoast.showToast(msg: res['message']);
      setState(() {
        _textEditingController.clear();
        load = false;
      });
    }else{
      Fluttertoast.showToast(msg: 'EnterMessageFirst'.trs(context));
    }
  }

  isAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userToken') != null) {
      setState(() {
        isAuthenticated = true;
      });
    }
  }


  @override
  void initState() {
    isAuth();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveAppBarBody(
        bottomViewOffset: Offset(0, -10),
        backgroundGradient: CColors.greenAppBarGradient(),
        pinned: true,
        actions: [HomePopUpMenu()],
        leading: BasketButton(),
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        child: !isAuthenticated ? NotAuthPage() : null,
        children:  !isAuthenticated
            ? null
            : [
          Text(
            "personal_assistant".trs(context),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: CColors.headerText,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(
              color: CColors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  offset: Offset(0.0, 8.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                  color: Color(0x10000000),
                ),
                BoxShadow(
                  offset: Offset(0.0, 3.0),
                  blurRadius: 14.0,
                  spreadRadius: 2.0,
                  color: Color(0x10000000),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: CColors.fadeGreen,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "To perfectly support you, please write down in details your inquires.".trs(context),
                        style: TextStyle(
                          color: CColors.lightGreen,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: CColors.brightLight, width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _textEditingController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'write_your_message'.trs(context),
                          focusColor: CColors.brightLight,
                          fillColor: CColors.brightLight,
                          contentPadding: EdgeInsetsDirectional.only(
                              start: 10, top: 9, bottom: 9),
                          hintStyle: TextStyle(fontSize: 12),
                          border: _buildBorder(),
                          focusedBorder: _buildBorder(),
                          enabledBorder: _buildBorder(),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: FlatButton.icon(
                      onPressed: () {
                        sendMessage();
                        // Navigator.of(
                        //   context,
                        //   rootNavigator: true,
                        // ).push(platformPageRoute(
                        //   context: context,
                        //   builder: (context) => SupportChat(),
                        // ));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      color: CColors.lightGreen,
                      icon: load
                          ? SpinKitFadingCircle(size: 20,color: CColors.white,)
                          : Icon(
                              CupertinoIcons.paperplane_fill,
                              color: CColors.white,
                              size: 16,
                            ),
                      label: Text(
                        "send".trs(context),
                        style: TextStyle(
                          color: CColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ShapeBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    );
  }
}
