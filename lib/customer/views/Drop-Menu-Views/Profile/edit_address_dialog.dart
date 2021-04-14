import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest/customer/models/city.dart';
import 'package:harvest/customer/models/delivery-data.dart';

import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'dart:ui' as ui;

import 'package:harvest/helpers/variables.dart';
import 'package:geocoder/geocoder.dart';
import 'package:harvest/widgets/dialogs/city_dialog.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harvest/helpers/Localization/localization.dart';

class EditAddressDialog extends StatefulWidget {
  final DeliveryAddresses deliveryAddresses;
  final int path;

  const EditAddressDialog({Key key, this.deliveryAddresses, this.path})
      : super(key: key);

  @override
  _EditAddressDialogState createState() => _EditAddressDialogState();
}

class _EditAddressDialogState extends State<EditAddressDialog> {
  final GlobalKey<FormState> _locationFormKey = GlobalKey<FormState>();
  City city;
  TextEditingController fullAddress, buildingNo, unitNo, additionalNotes,_city;
  double lat, lng;
  GoogleMapController _controller;
  List<Marker> markers = [];
  CameraPosition _initialCameraPosition;
  BitmapDescriptor customIcon;
  bool _visible = true;
  bool _load = false;
  bool _expand = false;
  bool loadFunc = false;
  Coordinates coordinates;

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
      markers = [];
      markers.add(
        Marker(
          position: LatLng(lat, lng),
          markerId: MarkerId('0'),
          icon: BitmapDescriptor.fromBytes(markerIcon), // icon: customIcon
        ),
      );
    });
  }

  editAddress() async {
    if (fullAddress.text != '' && additionalNotes.text != '') {
      if (city != null) {
        setState(() {
          _load = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var request = await post(
            ApiHelper.api + 'editAddress/${widget.deliveryAddresses.id}',
            body: {
              'lat': '${lat != null ? lat : widget.deliveryAddresses.lat}',
              'lan': '${lng != null ? lng : widget.deliveryAddresses.lan}',
              'address_name': '${fullAddress.text}',
              'address': '${fullAddress.text}',
              'city_id': '${city.id}',
              'building_number': '${buildingNo.text}',
              'unit_number': '${unitNo.text}',
              'note': '${additionalNotes.text}',
              // 'is_default': '${widget.deliveryAddresses.isDefault}',
            },
            headers: {
              'Accept': 'application/json',
              'Accept-Language': LangProvider().getLocaleCode(),
              'Authorization': 'Bearer ${prefs.getString('userToken')}'
            });
        var response = json.decode(request.body);
        print(response);
        if (response['status'] == true) {
          Navigator.pop(context);
        }
        setState(() {
          _load = false;
        });
      } else {
        Fluttertoast.showToast(msg: 'Select your city from extra details');
        setState(() {
          _expand = true;
        });
      }
    } else {
      setState(() {
        _expand = true;
      });
    }
  }

  @override
  void initState() {
    widget.path == 1 ? city = widget.deliveryAddresses.city : city = null;
    fullAddress =
        TextEditingController(text: widget.deliveryAddresses.address) ?? '';
    buildingNo = TextEditingController(
        text: widget.deliveryAddresses.buildingNumber != null
            ? widget.deliveryAddresses.buildingNumber.toString()
            : '');
    unitNo = TextEditingController(
        text: widget.deliveryAddresses.unitNumber != null
            ? widget.deliveryAddresses.unitNumber.toString()
            : '');
    additionalNotes = TextEditingController(
        text: widget.deliveryAddresses.note != null
            ? widget.deliveryAddresses.note
            : '');
    _city = TextEditingController(
        text: widget.deliveryAddresses.city.name != null
            ? widget.deliveryAddresses.city.name
            : '');
    _initialCameraPosition = CameraPosition(
      target:
          LatLng(widget.deliveryAddresses.lat, widget.deliveryAddresses.lan),
      zoom: 14.4746,
    );
    addMarker(widget.deliveryAddresses.lat, widget.deliveryAddresses.lan);
    super.initState();
  }

  @override
  void dispose() {
    fullAddress.dispose();
    buildingNo.dispose();
    unitNo.dispose();
    additionalNotes.dispose();
    _city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var op = Provider.of<CityOperations>(context);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Directionality(
        textDirection: LangProvider().getLocaleCode() == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Container(
          // width: size.width,
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
            mainAxisAlignment: MainAxisAlignment.start,
            // alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Container(
                  height: size.height * .6,
                  width: size.width * .8,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        child: Container(
                          height: size.height * .56,
                          width: size.width * .8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.0),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x24000000),
                                offset: Offset(0, 2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              GoogleMap(
                                mapType: MapType.normal,
                                zoomControlsEnabled: false,
                                mapToolbarEnabled: false,
                                trafficEnabled: false,
                                compassEnabled: false,
                                scrollGesturesEnabled: true,
                                initialCameraPosition: _initialCameraPosition,
                                markers: markers.toSet(),
                                onMapCreated: (controller) {
                                  setState(() {
                                    _controller = controller;
                                  });
                                },
                                onTap: (latLng) {
                                  _controller.animateCamera(
                                      CameraUpdate.newLatLng(latLng));
                                  setState(() {
                                    lat = latLng.latitude;
                                    lng = latLng.longitude;
                                  });
                                  addMarker(latLng.latitude, latLng.longitude);
                                },
                              ),
                              _load
                                  ? Container(
                                      color: Colors.black26,
                                      child: SpinKitFadingCircle(
                                        color: kPrimaryColor,
                                        size: 25,
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: AnimatedOpacity(
                            opacity: _visible ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 600),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              height: _expand ? 370 : 64,
                              width: size.width * .7,
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
                              child: _expand
                                  ? Form(
                                      key: _locationFormKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 15,),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Container(
                                              child: TextFormField(
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color:
                                                    const Color(0xff525768),
                                                  ),
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      barrierColor:
                                                      CColors.transparent,
                                                      barrierDismissible: true,
                                                      builder: (context) =>
                                                          Center(
                                                              child:
                                                              CityDropDown()),
                                                    ).then((value) {
                                                      if (value is Map<String,
                                                          dynamic>) {
                                                        setState(() {
                                                          city = value['city'];
                                                          if(city!=null){
                                                            _city.text = city.name;
                                                          }
                                                        });
                                                      }
                                                    });
                                                  },
                                                  validator: (value) =>
                                                      FieldValidator.validate(
                                                          value, context),
                                                  readOnly: true,
                                                  controller: _city,
                                                  cursorColor:
                                                  CColors.darkOrange,
                                                  cursorWidth: 1,
                                                  decoration:
                                                  locationFieldDecoration(
                                                      'city'
                                                          .trs(context))),
                                            ),
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.symmetric(
                                          //       vertical: 15, horizontal: 20),
                                          //   child: Stack(
                                          //     children: [
                                          //       GestureDetector(
                                          //         onTap: () {
                                          //           showDialog(
                                          //             barrierColor:
                                          //                 CColors.transparent,
                                          //             context: context,
                                          //             barrierDismissible: true,
                                          //             builder: (context) =>
                                          //                 Center(
                                          //                     child:
                                          //                         CityDropDown()),
                                          //           ).then((value) {
                                          //             if (value is Map<String,
                                          //                 dynamic>) {
                                          //               setState(() {
                                          //                 city = value['city'];
                                          //               });
                                          //             }
                                          //           });
                                          //         },
                                          //         child: Container(
                                          //           height: 50,
                                          //           decoration: BoxDecoration(
                                          //             borderRadius:
                                          //                 BorderRadius.circular(
                                          //                     12.0),
                                          //             border: Border.all(
                                          //                 width: 1.0,
                                          //                 color: const Color(
                                          //                     0xffe3e7eb)),
                                          //           ),
                                          //           child: Padding(
                                          //             padding: const EdgeInsets
                                          //                     .symmetric(
                                          //                 horizontal: 15),
                                          //             child: Row(
                                          //               mainAxisAlignment:
                                          //                   MainAxisAlignment
                                          //                       .spaceBetween,
                                          //               children: [
                                          //                 Text(
                                          //                   city != null
                                          //                       ? city.name
                                          //                       : 'city'.trs(
                                          //                           context),
                                          //                   style: TextStyle(
                                          //                     fontSize: 8,
                                          //                     color: const Color(
                                          //                         0xff525768),
                                          //                   ),
                                          //                 ),
                                          //                 SvgPicture.asset(
                                          //                     'assets/icons/arrow-down.svg')
                                          //               ],
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       // Container(
                                          //       //                          height: 50,
                                          //       //                          width: size.width * .75,
                                          //       //                          child: DropdownButton<City>(
                                          //       //                            icon: Container(),
                                          //       //                            underline: Container(),
                                          //       //                            items: op.items.values
                                          //       //                                .toList()
                                          //       //                                .map((City value) {
                                          //       //                              return DropdownMenuItem<
                                          //       //                                  City>(
                                          //       //                                value: value,
                                          //       //                                child: Text(
                                          //       //                                  value.name,
                                          //       //                                  style: TextStyle(
                                          //       //                                    fontSize: 10,
                                          //       //                                    color: const Color(
                                          //       //                                        0xff525768),
                                          //       //                                  ),
                                          //       //                                ),
                                          //       //                              );
                                          //       //                            }).toList(),
                                          //       //                            onChanged: (value) {
                                          //       //                              setState(() {
                                          //       //                                city = value;
                                          //       //                              });
                                          //       //                            },
                                          //       //                          ),
                                          //       //                        ),
                                          //     ],
                                          //   ),
                                          // ),
                                          SizedBox(height: 15,),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Container(
                                              child: TextFormField(
                                                validator: (value) =>
                                                    FieldValidator.validate(
                                                        value, context),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color:
                                                      const Color(0xff525768),
                                                ),
                                                controller: fullAddress,
                                                cursorColor: CColors.darkOrange,
                                                cursorWidth: 1,
                                                decoration:
                                                    locationFieldDecoration(
                                                  'Full address'.trs(context),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: size.width * .25,
                                                  child: Center(
                                                    child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: const Color(
                                                              0xff525768),
                                                        ),
                                                        controller: unitNo,
                                                        cursorColor:
                                                            CColors.darkOrange,
                                                        cursorWidth: 1,
                                                        decoration:
                                                            locationFieldDecoration(
                                                                'unit_no'.trs(
                                                                    context))),
                                                  ),
                                                ),
                                                Container(
                                                  width: size.width * .25,
                                                  child: Center(
                                                    child: TextFormField(
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: const Color(
                                                              0xff525768),
                                                        ),
                                                        controller: buildingNo,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        cursorColor:
                                                            CColors.darkOrange,
                                                        cursorWidth: 1,
                                                        decoration:
                                                            locationFieldDecoration(
                                                                'building_no'.trs(
                                                                    context))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Container(
                                              child: Stack(
                                                children: [
                                                  TextFormField(
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: const Color(
                                                            0xff525768),
                                                      ),
                                                      validator:
                                                          (value) =>
                                                              FieldValidator
                                                                  .validate(
                                                                      value,
                                                                      context),
                                                      controller:
                                                          additionalNotes,
                                                      maxLines: 5,
                                                      cursorColor:
                                                          CColors.darkOrange,
                                                      cursorWidth: 1,
                                                      decoration:
                                                          locationFieldDecoration(
                                                              'additional_note'
                                                                  .trs(
                                                                      context))),
                                                  // Positioned(
                                                  //     bottom: 5,
                                                  //     right: 5,
                                                  //     child: SvgPicture.asset(
                                                  //         'assets/icons/additional_icon.svg'))
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 25, right: 20, left: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // Container(
                                                //   child: Row(
                                                //     mainAxisSize: MainAxisSize.min,
                                                //     children: [
                                                //       Text(
                                                //         'Is Default Address'.trs(context),
                                                //         style: TextStyle(
                                                //           fontSize: 10,
                                                //           color:
                                                //               const Color(0xff525768),
                                                //         ),
                                                //       ),
                                                //       Switch(
                                                //         activeColor: CColors.darkOrange,
                                                //         value: widget.deliveryAddresses
                                                //                     .isDefault ==
                                                //                 1
                                                //             ? true
                                                //             : false,
                                                //         onChanged: (value) {
                                                //           value
                                                //               ? setState(() {
                                                //                   widget
                                                //                       .deliveryAddresses
                                                //                       .isDefault = 1;
                                                //                 })
                                                //               : setState(() {
                                                //                   widget
                                                //                       .deliveryAddresses
                                                //                       .isDefault = 0;
                                                //                 });
                                                //         },
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (_locationFormKey
                                                          .currentState
                                                          .validate()) {
                                                        if (city != null) {
                                                          setState(() {
                                                            _expand = false;
                                                          });
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg: 'Select your city first'
                                                                  .trs(
                                                                      context));
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 31,
                                                      width: 58,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        color: const Color(
                                                            0xfff88518),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'save'.trs(context),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: const Color(
                                                                0xffffffff),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _expand = true;
                                            });
                                          },
                                          child: Container(
                                            height: 31,
                                            width: 167,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: const Color(0xffe4f0e6),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'add_extra_details'.trs(context),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color:
                                                      const Color(0xff3c984f),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     save();
                                        //   },
                                        //   child: Container(
                                        //     width: 58,
                                        //     height: 31,
                                        //     decoration: BoxDecoration(
                                        //       borderRadius:
                                        //           BorderRadius.circular(5.0),
                                        //       color: const Color(0xfff88518),
                                        //     ),
                                        //     child: Center(
                                        //         child: Text(
                                        //       'Done',
                                        //       style: TextStyle(
                                        //
                                        //         fontSize: 12,
                                        //         color: const Color(0xffffffff),
                                        //         fontWeight: FontWeight.w500,
                                        //       ),
                                        //       textAlign: TextAlign.left,
                                        //     )),
                                        //   ),
                                        // )
                                      ],
                                    ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                  onTap: () => editAddress(),
                  child: Container(
                    height: 60,
                    width: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: const Color(0x0ff3C984F),
                    ),
                    child: Center(
                      child: Text(
                        'done_edit'.trs(context),
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xffffffff),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
