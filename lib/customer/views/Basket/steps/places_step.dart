import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/delivery-data.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/my_animation.dart';
import 'package:harvest/widgets/sheets/order_description.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaceStep extends StatefulWidget {
  final VoidCallback onContinue;

  const PlaceStep({Key key, this.onContinue}) : super(key: key);

  @override
  _PlaceStepState createState() => _PlaceStepState();
}

class _PlaceStepState extends State<PlaceStep> {
  bool load = false;

  BitmapDescriptor customIcon;
  List<Marker> markers = [];
  GoogleMapController _controller;

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
      markers.add(
        Marker(
          position: LatLng(lat, lng),
          markerId: MarkerId('$lat'),
          icon: BitmapDescriptor.fromBytes(markerIcon), // icon: customIcon
        ),
      );
    });
  }

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 12,
  // );

  // showDetails() {
  //   showModalBottomSheet(
  //       context: context,
  //       backgroundColor: CColors.transparent,
  //       isDismissible: false,
  //       enableDrag: false,
  //       builder: (context) => OrderDescription(
  //             onTap: () {
  //               widget.onContinue.call();
  //             },
  //           ),
  //       isScrollControlled: true);
  // }

  // @override
  // void initState() {
  //   SchedulerBinding.instance.addPostFrameCallback((_) {
  //       showDetails();
  //   });
  //   // addMarker(_kGooglePlex.target.latitude, _kGooglePlex.target.longitude);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    final size = MediaQuery.of(context).size;
    return Column(
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
        Container(
          height: size.height * .5,
          width: size.width * .9,
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
          child: Center(
            child: GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  _controller = controller;
                  addMarker(
                      cart.deliveryAddresses.lat, cart.deliveryAddresses.lan);
                });
              },
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    cart.deliveryAddresses.lat, cart.deliveryAddresses.lan),
                zoom: 12,
              ),
              markers: markers.toSet(),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.07),
      ],
    );
  }
}
