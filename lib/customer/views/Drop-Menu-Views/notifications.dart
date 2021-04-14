import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/customer/models/favorite.dart';
import 'package:harvest/customer/models/notifications.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/customer/views/Basket/basket.dart';
import 'package:harvest/customer/widgets/Fruit_item.dart';
import 'package:harvest/customer/widgets/notification_item.dart';
import 'package:harvest/helpers/Localization/lang_provider.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/widgets/backButton.dart';
import 'package:harvest/widgets/home_popUp_menu.dart';
import 'package:harvest/widgets/my_animation.dart';
import 'package:harvest/widgets/no_data.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool load = false;

  getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      load = true;
    });
    NotificationOperations op =
        Provider.of<NotificationOperations>(context, listen: false);
    op.clearNotes();
    var request = await get(ApiHelper.api + 'myNotifications', headers: {
      'Accept': 'application/json',
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    List values = response['items'];
    values.forEach((element) {
      NotificationM note = NotificationM.fromJson(element);
      op.addItem(note);
    });
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var op = Provider.of<NotificationOperations>(context);
    return Directionality(
      textDirection: LangProvider().getLocaleCode()=='ar'?TextDirection.rtl:TextDirection.ltr,
      child: Scaffold(
        body: WaveAppBarBody(
          backgroundGradient: CColors.greenAppBarGradient(),
          bottomViewOffset: Offset(0, -10),
          actions: [HomePopUpMenu()],
          leading: MyBackButton(),
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Notifications'.trs(context),
                style: TextStyle(
                  fontSize: 20,
                  color: const Color(0xff3c4959),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            load
                ? Center(
                    child:
                        Container(height: 200, width: 200, child: LoadingPhone()))
                : op.itemCount == 0
                    ? NoData()
                    : ListView.builder(
                        itemCount: op.items.length,
                        shrinkWrap: true,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => NoticeItem(
                          note: op.items.values.toList()[index],
                        ),
                      ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
