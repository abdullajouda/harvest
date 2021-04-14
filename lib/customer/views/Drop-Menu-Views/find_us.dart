import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/widgets/Loader.dart';
import 'package:harvest/widgets/backButton.dart';
import 'package:harvest/widgets/home_popUp_menu.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class FindUS extends StatefulWidget {
  @override
  _FindUSState createState() => _FindUSState();
}

class _FindUSState extends State<FindUS> {
  bool load = true;
  String facebook, twitter, instagram;
  String whatsapp, email, website;

  getSettings() async {
    var request =
        await get(ApiHelper.api + 'getSetting',headers: {
          'Accept': 'application/json',
          'Accept-Language': LangProvider().getLocaleCode(),
        });
    var response = json.decode(request.body)['items'];
    setState(() {
      facebook = response['facebook'];
      twitter = response['twitter'];
      instagram = response['instagram'];
      whatsapp = response['phone'];
      email = response['info_email'];
      website = response['url'];
      load = false;
    });
  }
  String url() {
    if (Platform.isAndroid) {
      // add the [https]
      return "https://wa.me/$whatsapp}"; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=$whatsapp"; // new line
    }
  }

  @override
  void initState() {
    getSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<_FindUSConnection> _socialMedia = [
      _FindUSConnection(
        iconPath: Constants.facebookIcon,
        handler: () async {
          await canLaunch(facebook)
              ? await launch(facebook)
              : Fluttertoast.showToast(msg: 'Cannot Launch $facebook');
        },
      ),
      _FindUSConnection(
        iconPath: Constants.twitterIcon,
        handler: () async {
          await canLaunch(twitter)
              ? await launch(twitter)
              : Fluttertoast.showToast(msg: 'Cannot Launch $twitter');
        },
      ),
      _FindUSConnection(
        iconPath: Constants.instagramIcon,
        handler: () async {
          await canLaunch(instagram)
              ? await launch(instagram)
              : Fluttertoast.showToast(msg: 'Cannot Launch $instagram');
        },
      ),
    ];
    List<_FindUSConnection> _hyperLinks = [
      _FindUSConnection(
        title: "WhatsApp",
        iconPath: Constants.whatsappIcon,
        titleStyle: TextStyle(color: Colors.green),
        handler: () async {
          await canLaunch(url())
              ? await launch(url())
              : Fluttertoast.showToast(msg: 'Cannot Launch $url');
        },
      ),
      _FindUSConnection(
        title: email,
        iconPath: Constants.mailIcon,
        titleStyle: TextStyle(color: CColors.darkOrange),
        handler: () async {
          await canLaunch('mailto:$email')
              ? await launch('mailto:$email')
              : Fluttertoast.showToast(msg: 'Cannot Launch $email');
        },
      ),
      _FindUSConnection(
        title: website,
        iconPath: Constants.webSiteIcon,
        titleStyle: TextStyle(color: CColors.headerText),
        handler: () async {
          await canLaunch('https:$website')
              ? await launch('https:$website')
              : Fluttertoast.showToast(msg: 'Cannot Launch $website');
        },
      ),
    ];
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
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              Text(
                "find_us".trs(context),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: CColors.headerText,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _socialMedia.length,
                  (index) {
                    final _connection = _socialMedia[index];
                    return _CSupportContainer(
                      size: Size(60, 60),
                      onTap: _connection.handler,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SvgPicture.asset(_connection.iconPath),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: size.height * 0.1),
              load
                  ? Center(child: Loader())
                  : Column(
                      children: List.generate(
                        _hyperLinks.length,
                        (index) {
                          final _hyperLink = _hyperLinks[index];
                          return _CSupportContainer(
                            size: Size(size.width * 0.5, 50),
                            onTap: _hyperLink.handler,
                            margin: EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                Expanded(
                                    child: SvgPicture.asset(_hyperLink.iconPath)),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    _hyperLink.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ).merge(_hyperLink.titleStyle),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class _FindUSConnection {
  final String title;
  final String iconPath;
  final VoidCallback handler;
  final TextStyle titleStyle;

  const _FindUSConnection({
    this.title,
    this.iconPath,
    this.handler,
    this.titleStyle,
  });
}

class _CSupportContainer extends StatelessWidget {
  final VoidCallback onTap;
  final Size size;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const _CSupportContainer({
    Key key,
    this.onTap,
    @required this.size,
    this.child,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color _kKeyUmbraOpacity = Color(0x20000000); // alpha = 0.2
    return Padding(
      padding: margin ?? const EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: size?.width,
            height: size?.height,
            decoration: BoxDecoration(
              color: CColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  offset: Offset(0.0, 3.0),
                  blurRadius: 4.0,
                  spreadRadius: -1.0,
                  color: _kKeyUmbraOpacity,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
