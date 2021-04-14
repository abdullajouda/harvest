import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/customer/models/favorite.dart';
import 'package:harvest/customer/models/offers_slider.dart';
import 'package:harvest/customer/models/products.dart';

import 'package:harvest/customer/widgets/Fruit_item.dart';
import 'package:harvest/helpers/Localization/lang_provider.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/color_converter.dart';
import 'package:harvest/helpers/colors.dart';

import 'package:harvest/widgets/backButton.dart';
import 'package:harvest/widgets/my_animation.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OffersPage extends StatefulWidget {
  final Offers offers;
  final String color;

  const OffersPage({Key key, this.offers, this.color}) : super(key: key);

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {

  List<Products> _products = [];
  bool loadProducts = false;

  getProductsByParent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loadProducts = true;
    });
    var request = await get(
        ApiHelper.api + 'getOffers/${widget.offers.categoryId}',
        headers: {
          'Accept': 'application/json',
          'fcmToken': prefs.getString('fcm_token'),
          'Accept-Language': LangProvider().getLocaleCode(),
          'Authorization': 'Bearer ${prefs.getString('userToken')}'
        });
    var response = json.decode(request.body);
    List values = response['items'];
    values.forEach((element) {
      Products products = Products.fromJson(element);
      _products.add(products);
    });
    setState(() {
      loadProducts = false;
    });
  }


  @override
  void initState() {
    getProductsByParent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveAppBarBody(
        bottomViewOffset: Offset(0, -10),
        backgroundGradient: CColors.gradientGenerator(
            color1: HexColor.fromHex(widget.color),
            color2: HexColor.fromHex(widget.color)),
        shadowColor: HexColor.fromHex(widget.color),
        leading: MyBackButton(),
        actions: [Container()],
        bottomView: Card(
          // margin: EdgeInsets.symmetric(horizontal: size.width * 0.13),
          elevation: 10,
          shadowColor: Colors.black26,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          child: Container(
              decoration: BoxDecoration(
                // color: Colors.teal,
                borderRadius: BorderRadius.circular(999),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                widget.offers.title,
                style: TextStyle(
                  color: HexColor.fromHex(widget.color),
                  fontWeight: FontWeight.w500,
                ),
              )
              // Text.rich(
              //   TextSpan(
              //     text: "Save Up to 50%" + "\t\t",
              //     style: TextStyle(
              //       color: HexColor.fromHex(widget.color),
              //       fontWeight: FontWeight.w500,
              //     ),
              //     children: [
              //       TextSpan(
              //         text: "April Offers",
              //         style: TextStyle(
              //           color: CColors.normalText,
              //           fontWeight: FontWeight.normal,
              //           fontSize: 13,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              ),
        ),
        children: [
          // FlatButton(
          //   onPressed: () {
          //     Navigator.of(context, rootNavigator: true).push(platformPageRoute(
          //       context: context,
          //       builder: (context) => ProductBundleDetails(),
          //     ));
          //
          //     // AlertManager.showDropDown(
          //     //   alertBody: AlertBody(
          //     //     title: "added successfully to Cart",
          //     //     message: "You can find it in your cart  screen",
          //     //     icon: Icon(
          //     //       Icons.check,
          //     //     ),
          //     //   ),
          //     // );
          //   },
          //   child: Text("Go to Bundle"),
          // ),
          loadProducts? Center(
              child: Container(
                  height: 200, width: 200, child: LoadingPhone()))
              : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18),
              itemCount: _products.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                  return GestureDetector(
                    // onTap: () =>
                    //     Navigator.of(context, rootNavigator: true).push(
                    //   CupertinoPageRoute(
                    //     builder: (context) => ProductDetails(
                    //       fruit: op.homeItems.values.toList()[index],
                    //     ),
                    //   ),
                    // ),
                    child: FruitItem(
                      fruit:_products[index],
                      color: HexColor.fromHex(widget.color),
                    ),
                  );
                }
               )
        ],
      ),
    );
  }

  @override
  void reassemble() {
    super.reassemble();
  }
}
