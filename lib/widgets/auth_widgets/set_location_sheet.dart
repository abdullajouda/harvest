import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest/customer/models/city.dart';
import 'package:harvest/customer/models/delivery-data.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/terms.dart';
import 'package:harvest/customer/views/root_screen.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:harvest/widgets/directions.dart';
import 'dart:ui' as ui;

import 'package:harvest/helpers/variables.dart';
import 'package:geocoder/geocoder.dart';
import 'package:harvest/widgets/dialogs/city_dialog.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:harvest/helpers/Localization/localization.dart';

class SetLocationSheet extends StatefulWidget {
  final bool isEdit;
  final DeliveryAddresses address;

  const SetLocationSheet({Key key, this.isEdit = false, this.address}) : super(key: key);
  @override
  _SetLocationSheetState createState() => _SetLocationSheetState();
}

class _SetLocationSheetState extends State<SetLocationSheet> {
  final GlobalKey<FormState> _locationFormKey = GlobalKey<FormState>();
  City city;
  TextEditingController fullAddress, buildingNo, unitNo, additionalNotes,_city;
  GoogleMapController _controller;
  List<Marker> markers = [];
  CameraPosition _initialCameraPosition;
  BitmapDescriptor customIcon;
  bool _visible;
  bool _load = false;
  bool _expand = false;
  Coordinates coordinates;
  int group = 0;

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

  Future<Position> _determinePosition() async {
    setState(() {
      _load = true;
    });
    final Uint8List markerIcon = await getBytesFromAsset('assets/Pin.png', 100);
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _controller.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude), 15));
      setState(() {
        coordinates = new Coordinates(position.latitude, position.longitude);
        markers = [];
        markers.add(Marker(
            icon: BitmapDescriptor.fromBytes(markerIcon),
            position: LatLng(position.latitude, position.longitude),
            markerId: MarkerId('0')));
        _load = false;
        _visible = true;
      });
    }
    setState(() {
      _load = false;
      _visible = true;
    });
    return await Geolocator.getCurrentPosition();
  }

  // Future getCities() async {
  //   var op = Provider.of<CityOperations>(context,listen: false);
  //   var request = await get(ApiHelper.api + 'getCities', headers: {
  //     'Accept': 'application/json',
  //     'Accept-Language': LangProvider().getLocaleCode(),
  //   });
  //   var response = json.decode(request.body);
  //   var items = response['cities'];
  //   op.clearCity();
  //   items.forEach((element) {
  //     City city = City.fromJson(element);
  //     op.addItem(city);
  //     print(city.name);
  //   });
  // }

  save() async {
    if (fullAddress.text != '' &&
        additionalNotes.text != '') {
      if (city != null) {
        if (markers[0] != null) {
          Navigator.of(context).pop({
            'addressLine': fullAddress.text,
            'latitude': markers[0].position.latitude,
            'longitude': markers[0].position.longitude,
            'city': city,
            'buildingNo': buildingNo.text,
            'unitNo': unitNo.text,
            'additionalNotes': additionalNotes.text,
          });
        } else {
          Fluttertoast.showToast(
              msg: 'Select your location on map first'.trs(context));
        }
      } else {
        Fluttertoast.showToast(msg: 'Select your city first'.trs(context));
        setState(() {
          _expand = true;
        });
      }
    }else{
      setState(() {
        // Fluttertoast.showToast(msg: 'All Fields are Required'.trs(context));
        _expand = true;
      });
    }
  }

  @override
  void initState() {
    // getCities();
    if(widget.isEdit == true){
      setState(() {
        _visible = true;
        city = widget.address.city;
      });
      fullAddress = TextEditingController(text: widget.address.address);
      additionalNotes = TextEditingController(text: widget.address.note);
      buildingNo = TextEditingController(text: widget.address.buildingNumber.toString());
      unitNo = TextEditingController(text: widget.address.unitNumber.toString());
      _city = TextEditingController(text: widget.address.city.name);
      _initialCameraPosition = CameraPosition(
        target: LatLng(widget.address.lat, widget.address.lan),
        zoom: 14.4746,
      );
      addMarker(widget.address.lat, widget.address.lan);
    }else{
      _visible = false;
      fullAddress = TextEditingController();
      additionalNotes = TextEditingController();
      buildingNo = TextEditingController();
      unitNo = TextEditingController();
      _city = TextEditingController();

      _determinePosition();
      _initialCameraPosition = CameraPosition(
        target: LatLng(31, 31),
        zoom: 14.4746,
      );
    }
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
    return Direction(
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
                        height: size.height * .57,
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
                              // scrollGesturesEnabled: false,
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
                            height: _expand ? 400 : 64,
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
                                                validator: (value) =>
                                                    FieldValidator.validate(
                                                        value, context),
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
                                        //
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
                                        //       //   height: 50,
                                        //       //   width: size.width * .75,
                                        //       //   child: DropdownButton<City>(
                                        //       //     icon: Container(),
                                        //       //     underline: Container(),
                                        //       //     items: op.items.values
                                        //       //         .toList()
                                        //       //         .map((City value) {
                                        //       //       return DropdownMenuItem<
                                        //       //           City>(
                                        //       //         value: value,
                                        //       //         child: Text(
                                        //       //           value.name,
                                        //       //           style: TextStyle(
                                        //       //             fontSize: 8,
                                        //       //             color: const Color(
                                        //       //                 0xff525768),
                                        //       //           ),
                                        //       //         ),
                                        //       //       );
                                        //       //     }).toList(),
                                        //       //     onChanged: (value) {
                                        //       //       setState(() {
                                        //       //         city = value;
                                        //       //       });
                                        //       //     },
                                        //       //   ),
                                        //       // ),
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
                                                  fontSize: 8,
                                                  color: const Color(0xff525768),
                                                ),
                                                controller: fullAddress,
                                                cursorColor: CColors.darkOrange,
                                                cursorWidth: 1,
                                                decoration: locationFieldDecoration(
                                                    'Full address'.trs(context))),
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
                                                      style: TextStyle(
                                                        fontSize: 8,
                                                        color:
                                                            const Color(0xff525768),
                                                      ),
                                                      controller: unitNo,
                                                      keyboardType: TextInputType.number,
                                                      cursorColor:
                                                          CColors.darkOrange,
                                                      cursorWidth: 1,
                                                      decoration:
                                                          locationFieldDecoration(
                                                              'unit_no'
                                                                  .trs(context))),
                                                ),
                                              ),
                                              Container(
                                                width: size.width * .25,
                                                child: Center(
                                                  child: TextFormField(
                                                      style: TextStyle(
                                                        fontSize: 8,
                                                        color:
                                                            const Color(0xff525768),
                                                      ),
                                                      controller: buildingNo,
                                                      keyboardType: TextInputType.number,

                                                      cursorColor:
                                                          CColors.darkOrange,
                                                      cursorWidth: 1,
                                                      decoration:
                                                          locationFieldDecoration(
                                                              'building_no'
                                                                  .trs(context))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                                                validator: (value) =>
                                                    FieldValidator.validate(
                                                        value, context),
                                                controller: additionalNotes,
                                                maxLines: 5,
                                                keyboardType: TextInputType.multiline,
                                                cursorColor: CColors.darkOrange,
                                                cursorWidth: 1,
                                                decoration:
                                                    locationFieldDecoration(
                                                        'additional_note'
                                                            .trs(context),),),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 25, right: 20),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                if (_locationFormKey.currentState
                                                    .validate()) {
                                                  setState(() {
                                                    _expand = false;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height: 31,
                                                width: 58,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5.0),
                                                  color: const Color(0xfff88518),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'save'.trs(context),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          const Color(0xffffffff),
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),
                                            ),
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
                                                color: const Color(0xff3c984f),
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => save(),
                  child: Container(
                    height: 60,
                    width: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: const Color(0x0ff3C984F),
                    ),
                    child: Center(
                      child: Text(
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
                    width: size.width,
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
                        //     'skip'.trs(context),
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
