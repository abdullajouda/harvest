import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/delivery_time_avaiable.dart';
import 'package:harvest/widgets/address_list_tile.dart';
import 'package:harvest/widgets/sheets/available_dates_sheet.dart';

// import 'package:intl/intl.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class DeliveryTimeStep extends StatefulWidget {
  @override
  _DeliveryTimeStepState createState() => _DeliveryTimeStepState();
}

class _DeliveryTimeStepState extends State<DeliveryTimeStep> {
  DateTime _currentDateTime;
  Set<Marker> _markers = {};
  AvailableDates availableDates;
  Times time;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  addMarker(double lat, double lng) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/Pin.png', 100);
    setState(() {
      // markers = [];
      _markers.add(
        Marker(
          position: LatLng(lat, lng),
          markerId: MarkerId('$lat'),
          icon: BitmapDescriptor.fromBytes(markerIcon), // icon: customIcon
        ),
      );
    });
  }

  @override
  void initState() {
    var cart = Provider.of<Cart>(context, listen: false);
    addMarker(cart.deliveryAddresses.lat, cart.deliveryAddresses.lan);
    _currentDateTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var cart = Provider.of<Cart>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "delivery_place".trs(context),
            style: TextStyle(
              color: CColors.headerText,
              fontSize: 15,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
            height: size.height * 0.2,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: CColors.white,
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(10),
                                offset: Offset(0, 5.0),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: GoogleMap(
                              zoomGesturesEnabled: false,
                              scrollGesturesEnabled: false,
                              myLocationButtonEnabled: false,
                              myLocationEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    cart.deliveryAddresses.lat != null
                                        ? cart.deliveryAddresses.lat
                                        : 37.42796133580664,
                                    cart.deliveryAddresses.lan != null
                                        ? cart.deliveryAddresses.lan
                                        : 41.085749655962),
                                zoom: 12,
                              ),
                              markers: _markers,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.06),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: size.width * .6,
                      decoration: BoxDecoration(
                        color: CColors.white,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            offset: Offset(0, 7.0),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      child: AddressListTile(
                        title:
                            "${cart.deliveryAddresses.city.name}, ${cart.deliveryAddresses.street != null ? cart.deliveryAddresses.street : ''}",
                        subTitle:
                            "${cart.deliveryAddresses.buildingNumber}, ${cart.deliveryAddresses.unitNumber}",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "delivery_date_time".trs(context),
            style: TextStyle(
              color: CColors.headerText,
              fontSize: 15,
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                availableDates != null
                    ? Container(
                        decoration: BoxDecoration(
                          color: CColors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(7),
                              offset: Offset(0, 5.0),
                              spreadRadius: 1,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 50,
                                width: 5,
                                color: CColors.lightGreen,
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Column(
                                      children: [
                                        Text(
                                          availableDates.month,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: CColors.lightGreen,
                                          ),
                                        ),
                                        Text(
                                          availableDates.date
                                              .replaceRange(
                                                  6,
                                                  availableDates.date.length,
                                                  '')
                                              .replaceRange(0, 4, ''),
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: CColors.lightGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          children: [
                                            Text(
                                              "${availableDates.dayName}, ",
                                              style: TextStyle(
                                                color: CColors.headerText,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              " ${time.from != null ? time.from : ''} ${'to'.trs(context)} ",
                                              style: TextStyle(
                                                color: CColors.headerText,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              " ${time.to != null ? time.to : ''} ",
                                              style: TextStyle(
                                                color: CColors.headerText,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "at_this_time".trs(context),
                                          style: TextStyle(
                                            color: CColors.normalText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "pickup_new_suitable_date".trs(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CColors.grey,
                      fontSize: 11,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: CColors.transparent,
                      enableDrag: true,
                      builder: (context) => AvailableDatesSheet(),
                    ).then((value) {
                      if (value is Map<String, dynamic>) {
                        if (value['deliveryDate'] != null &&
                            value['deliveryTime'] != null) {
                          setState(() {
                            availableDates = value['deliveryDate'];
                            time = value['deliveryTime'];
                          });
                          return;
                        }
                      }
                    });
                    // DatePicker.showDateTimePicker(
                    //   context,
                    //   onConfirm: (time) {
                    //     setState(() {
                    //       _deliveryTime = _DeliveryTimeModel.fromTime(time);
                    //     });
                    //   },
                    //   onChanged: (time) {
                    //     final String _time = DateFormat("h:mm a").format(time);
                    //     // ignore: unused_local_variable
                    //     final String _date = DateFormat("d").format(time);
                    //     // ignore: unused_local_variable
                    //     final String _month = DateFormat("MMMM").format(time);
                    //     // ignore: unused_local_variable
                    //     final _timeFormated2 = DateFormat("EE, MMMM d, h:mm aaa").format(time);
                    //     print(_time);
                    //     setState(() {
                    //       _deliveryTime = _DeliveryTimeModel.fromTime(time);
                    //     });
                    //   },
                    //   currentTime: DateTime.now(),
                    //   maxTime: DateTime.now().add(Duration(days: 30)),
                    //   minTime: DateTime.now().subtract(Duration(days: 30)),
                    //   locale: LocaleType.ar,
                    // );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: CColors.fadeBlue,
                  child: Text(
                    "change_date_time".trs(context),
                    style: TextStyle(
                      color: CColors.darkGreen,
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            )),
        // BasketPagesControlles(),
      ],
    );
  }
}
