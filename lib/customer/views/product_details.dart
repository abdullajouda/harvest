import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/favorite.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/customer/widgets/custom_icon_button.dart';
import 'package:harvest/customer/widgets/custom_main_button.dart';
import 'package:harvest/customer/widgets/make_favorite_button.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/button_loader.dart';
import 'package:harvest/widgets/dialogs/alert_builder.dart';
import 'package:harvest/widgets/directions.dart';
import 'package:harvest/widgets/favorite_button.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  final Products fruit;

  ProductDetails({Key key, this.fruit}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final color = const Color(0xffFDAA5C);
  bool load = false;

  addToBasket(int id) async {
    setState(() {
      load = true;
    });
    var cart = Provider.of<Cart>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await post(ApiHelper.api + 'addProductToCart/$id}', headers: {
      'Accept': 'application/json',
      'fcmToken': prefs.getString('fcm_token'),
      'Accept-Language': prefs.getString('language'),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    if (response['status'] == true) {
      showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.1),
        transitionDuration: Duration(milliseconds: 400),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return GestureDetector(onTap: () => Navigator.pop(context),
            child: AlertBuilder(
              title: 'Added Successfully To Cart',
              subTitle: 'You can find it in your cart  screen',
              color: CColors.lightGreen,
              icon: Icon(
                Icons.check,
                color: CColors.white,
                size: 25,
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position:
            Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
      var items = response['cart'];
      if (items != null) {
        cart.clearFav();
        items.forEach((element) {
          CartItem item = CartItem.fromJson(element);
          cart.addItem(item);
        });
        setState(() {
          widget.fruit.inCart = widget.fruit.inCart + widget.fruit.unitRate;
        });
      }
    }
    // Fluttertoast.showToast(msg: response['message']);
    setState(() {
      load = false;
    });
  }

  changeQnt(int type, int id) async {
    setState(() {
      load = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await post(ApiHelper.api + 'changeQuantity', body: {
      'type': type.toString(),
      'product_id': id.toString()
    }, headers: {
      'Accept': 'application/json',
      'fcmToken': prefs.getString('fcm_token'),
      'Accept-Language': prefs.getString('language'),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    if(response['message'] == 'product deleted'){
      showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.1),
        transitionDuration: Duration(milliseconds: 400),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return GestureDetector(onTap: () => Navigator.pop(context),
            child: AlertBuilder(
              title: 'The Item Removed',
              subTitle: 'The item was removed from your cart',
              color: CColors.lightOrangeAccent,
              icon: SvgPicture.asset('assets/trash.svg'),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position:
            Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
    }
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // var cart = Provider.of<Cart>(context);
    return Direction(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: color,
          leading: Padding(
            padding: const EdgeInsets.all(3.0),
            // child: CBackButton(),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Container(
            color: color,
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Image.network(
                    widget.fruit.image,
                    height: 320,
                    width: 320,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, -1.5),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 20, bottom: 20),
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.fruit.name ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: CColors.headerText,
                                  fontSize: 23,
                                ),
                              ),
                              Text(
                                "${widget.fruit.available} ${widget.fruit.typeName}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: CColors.headerText.withAlpha(150),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                         Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  widget.fruit.inCart == 0
                                      ? Container()
                                      :Row(
                                    children: [
                                      CIconButton(
                                        onTap: () {
                                          changeQnt(2, widget.fruit.id);
                                          setState(() {
                                            widget.fruit.inCart = widget.fruit.inCart - widget.fruit.unitRate;
                                          });
                                        },
                                        icon: Icon(Icons.remove,
                                            color: CColors.headerText, size: 25),
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: size.width * 0.12,
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.fruit.inCart.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: CColors.headerText,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      CIconButton(
                                        onTap: () {
                                          changeQnt(1, widget.fruit.id);
                                          setState(() {
                                            widget.fruit.inCart = widget.fruit.inCart + widget.fruit.unitRate;
                                          });
                                        },
                                        icon: Icon(Icons.add,
                                            color: CColors.headerText, size: 25),
                                      ),
                                      // if (_qty == 0)
                                      //   Text("add_to_basket".trs(context),
                                      //       style: TextStyle(
                                      //           fontSize: 13, color: CColors.grey)),
                                    ],
                                  ),
                                  Text(
                                    "${"Q.R".trs(context)} ${widget.fruit.price} ",
                                    style: TextStyle(
                                      color: CColors.headerText,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: 10),
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "product_description".trs(context),
                                  style: TextStyle(
                                    color: CColors.headerText,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Expanded(
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      widget.fruit.description ?? '',
                                      style: TextStyle(
                                        color: CColors.normalText,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 56.0,
                              height: 52.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.0),
                                border: Border.all(
                                    width: 2.0, color: const Color(0xff3c984f)),
                              ),
                              child: Center(
                                  child: FavoriteButton(
                                color: CColors.darkGreen,
                                fruit: widget.fruit,
                              )),
                            ),
                            SizedBox(width: 10),
                            widget.fruit.inCart != 0
                                ? Container()
                                : Expanded(
                                    child: load
                                        ? Center(child: LoadingBtn())
                                        : MainButton(
                                            onTap: () {
                                              addToBasket(widget.fruit.id);
                                            },
                                            constraints:
                                                BoxConstraints(maxHeight: 50),
                                            titleTextStyle:
                                                TextStyle(fontSize: 15),
                                            title: 'add_to_basket'.trs(context),
                                          ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
