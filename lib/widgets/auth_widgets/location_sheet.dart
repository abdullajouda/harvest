import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/models/city.dart';
import 'package:harvest/customer/models/delivery-data.dart';
import 'package:harvest/customer/models/user.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/terms.dart';
import 'package:harvest/customer/views/root_screen.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:harvest/helpers/services.dart';
import 'package:harvest/widgets/auth_widgets/set_location_sheet.dart';
import 'package:harvest/widgets/button_loader.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harvest/helpers/Localization/localization.dart';

import '../directions.dart';

class LocationSheet extends StatefulWidget {
  final String name;
  final String mobile;

  const LocationSheet({Key key, this.name, this.mobile}) : super(key: key);

  @override
  _LocationSheetState createState() => _LocationSheetState();
}

class _LocationSheetState extends State<LocationSheet> {
  double lat, lng;
  var fullAddress;
  var buildingNo;
  var unitNo;
  var additionalNotes;
  City city;
  bool load = false;
  String deviceType;
  int group = 0;

  onContinue() async {
    if (Platform.isIOS) {
      deviceType = "ios";
    } else {
      deviceType = 'android';
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      load = true;
    });
    if (lat != null && lng != null) {
      // FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
      // final fToken = await _firebaseMessaging.getToken();
      String fToken = prefs.getString('fcm_token');
      var request = await post(ApiHelper.api + 'signUp', body: {
        'name': widget.name,
        'mobile': widget.mobile,
        'device_type': deviceType,
        'fcm_token': fToken,
        'lat': '$lat',
        'lan': '$lng',
        'full_address': '$fullAddress',
        'city': '${city.id}',
        'building_no': '${buildingNo.toString()}',
        'unit_no': '${unitNo.toString()}',
        'additional_notes': '$additionalNotes',
      }, headers: {
        'Accept': 'application/json',
        'Accept-Language': prefs.getString('language'),
      });
      var response = json.decode(request.body);
      var op = Provider.of<UserFunctions>(context, listen: false);
      DeliveryAddresses addresses =
          DeliveryAddresses.fromJson(response['user']['delivery_addresses'][0]);
      // Fluttertoast.showToast(msg: response['message']);
      if (response['status'] == true) {
        prefs.setString('userToken', response['user']['access_token']);
        prefs.setInt('loginCount', 1);
        Services().setUser(
            response['user']['id'],
            response['user']['city_id'],
            response['user']['name'],
            response['user']['email'],
            response['user']['mobile'],
            response['user']['image_profile']);
        Services().setDefaultAddress(
          addresses.id,
          address: addresses.address,
          buildingNumber: addresses.buildingNumber,
          city: addresses.city.name,
          deliveryCost: addresses.city.deliveryCost,
          lat: addresses.lat,
          lng: addresses.lan,
          minOrder: addresses.city.minOrder,
          unitNumber: addresses.unitNumber,
        );
        op.setUser(
          User(
            id: response['user']['id'],
            name: response['user']['name'],
            mobile: response['user']['mobile'],
            email: response['user']['email'],
            cityId: response['user']['city_id'],
            imageProfile: response['user']['image_profile'],
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RootScreen(),
          ),
        );
      }
    } else {
      Fluttertoast.showToast(msg: 'Please set your location'.trs(context));
    }
    setState(() {
      load = false;
    });
  }

  openMap({bool isEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => isEdit
          ? SetLocationSheet(
              isEdit: true,
              address: DeliveryAddresses(
                  city: city,
                  lat: lat,
                  lan: lng,
                  address: fullAddress,
                  buildingNumber: int.parse(buildingNo),
                  unitNumber: int.parse(unitNo),
                  note: additionalNotes),
            )
          : SetLocationSheet(),
    ).then((value) {
      if (value is Map<String, dynamic>) {
        if (value['addressLine'] == null) {
          setState(() {
            lat = value['latitude'];
            lng = value['longitude'];
            city = value['city'];
            buildingNo = value['buildingNo'];
            unitNo = value['unitNo'];
            additionalNotes = value['additionalNotes'];
          });
          return;
        }
        setState(() {
          fullAddress = value['addressLine'];
          lat = value['latitude'];
          lng = value['longitude'];
          city = value['city'];
          buildingNo = value['buildingNo'];
          unitNo = value['unitNo'];
          additionalNotes = value['additionalNotes'];
        });
      }
    });
  }

  // Navigator.of(context).pop({
  // 'dataLocation': addresses.first.addressLine,
  // 'latitude': markers[0].position.latitude,
  // 'longitude': markers[0].position.longitude
  // });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Direction(
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
          // alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Container(
                // height: 160,
                width: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.0),
                  color: const Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x14000000),
                      offset: Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    city != null && (lat != null && lng != null)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              height: 68,
                              width: 218,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 200,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: const Color(0xfffff7ef),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: SvgPicture.asset(
                                                'assets/images/Pin.svg'),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${city.name}, $fullAddress' ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: const Color(0xff3c4959),
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                ' $unitNo, $buildingNo',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: const Color(0xff888a8d),
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                textAlign: TextAlign.left,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () => openMap(isEdit: true),
                                      child: Container(
                                        height: 18,
                                        width: 18,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(9999.0, 9999.0)),
                                          color: const Color(0xfff88518),
                                          border: Border.all(
                                              width: 1.0,
                                              color: const Color(0xffffffff)),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                              'assets/icons/edit.svg'),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        'Add new specific address'.trs(context),
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xff888a8d),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: GestureDetector(
                        onTap: () => openMap(isEdit: false),
                        child: Container(
                          height: 31,
                          width: 147,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: const Color(0xffe4f0e6),
                          ),
                          child: Center(
                            child: Text(
                              'add_new_adress'.trs(context),
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xff3c984f),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => onContinue(),
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
                                  unselectedWidgetColor: Colors.grey[300]),
                              child: Radio<int>(
                                value: 0,
                                groupValue: group,
                                activeColor: CColors.darkGreen,
                                onChanged: (value) {},
                              ),
                            ),
                            Text(
                              'By Continuing you agree to our'.trs(context),
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
                                'Terms of use'.trs(context),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: const Color(0xff3c984f),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         CustomPageRoute(
                        //           builder: (context) => RootScreen(),
                        //         ));
                        //   },
                        //   child: Text(
                        //     'Skip'.trs(context),
                        //     style: TextStyle(
                        //       fontSize: 10,
                        //       color: const Color(0xfffdaa5c),
                        //     ),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
