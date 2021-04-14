import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:harvest/helpers/Localization/localization.dart';

import 'package:flutter/material.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/customer/models/pages.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/Loader.dart';
import 'package:harvest/widgets/backButton.dart';
import 'package:harvest/widgets/home_popUp_menu.dart';
import 'package:http/http.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  bool load = true;
  Pages _aboutUs;

  getSettings() async {
    var request =
        await get(ApiHelper.api + 'getSetting', headers: {
          'Accept': 'application/json',
          'Accept-Language': LangProvider().getLocaleCode(),
        });
    var response = json.decode(request.body)['items'];
    Pages model = Pages.fromJson(response['aboutUs']);
    setState(() {
      _aboutUs = model;
      load = false;
    });
  }

  @override
  void initState() {
    getSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: LangProvider().getLocaleCode()=='ar'?TextDirection.rtl:TextDirection.ltr,
      child: Scaffold(
        appBar: WaveAppBar(
          leading: MyBackButton(),
          bottomViewOffset: Offset(0, -10),
          backgroundGradient: CColors.greenAppBarGradient(),
          actions: [HomePopUpMenu()],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "about_us".trs(context),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: CColors.headerText,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    load
                        ? Center(child: Loader())
                        : SingleChildScrollView(
                            child: Container(
                              width: size.width * .95,
                              child: Html(
                                data:
                                    _aboutUs.description.replaceAll("\\r\\n", '') ?? '',
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
