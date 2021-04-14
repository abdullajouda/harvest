import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/favorite.dart';
import 'package:harvest/customer/models/featured_product.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/customer/widgets/custom_icon_button.dart';
import 'package:harvest/customer/widgets/custom_main_button.dart';
import 'package:harvest/customer/widgets/make_favorite_button.dart';

import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/color_converter.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/alerts/myAlerts.dart';
import 'package:harvest/widgets/alerts/removed_from_cart.dart';
import 'package:harvest/widgets/backButton.dart';
import 'package:harvest/widgets/button_loader.dart';
import 'package:harvest/widgets/dialogs/signup_first.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductBundleDetails extends StatefulWidget {
  final FeaturedProduct fruit;

  ProductBundleDetails({
    Key key,
    this.fruit,
  }) : super(key: key);

  @override
  _ProductBundleDetailsState createState() => _ProductBundleDetailsState();
}

class _ProductBundleDetailsState extends State<ProductBundleDetails> {
  bool _isFavorite = false;
  bool load = false;
  bool loadProducts = false;

  addToBasket(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cart = Provider.of<Cart>(context, listen: false);
    setState(() {
      widget.fruit.inCart = widget.fruit.inCart + widget.fruit.unitRate;
    });
    MyAlert.addedToCart(0, context);
    // cart.addItem(CartItem(
    //   productId: widget.fruit.id,
    //   quantity: widget.fruit.inCart,
    //   product: Products(
    //       id: widget.fruit.id,
    //       name: widget.fruit.name,
    //       image: widget.fruit.image,
    //       inCart: widget.fruit.inCart,
    //       typeName: widget.fruit.typeName,
    //       type: widget.fruit.type,
    //       isFavorite: widget.fruit.inFavorite,
    //       priceOffer: widget.fruit.priceOffer,
    //       discount: widget.fruit.discount,
    //       price: widget.fruit.price.toDouble()),
    //   fcmToken: prefs.getString('fcm_token'),
    // ));
    var request = await post(ApiHelper.api + 'addProductToCart/$id', headers: {
      'Accept': 'application/json',
      'fcmToken': prefs.getString('fcm_token'),
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    // MyAlert.addedToCart(0, context);
    print(response);
    if (response['status'] == true) {
      var items = response['cart'];
      if (items != null) {
        items.forEach((element) {
          CartItem item = CartItem.fromJson(element);
          cart.addItem(item);
          setState(() {});
        });
      }
    }
    // Fluttertoast.showToast(msg: response['message']);
  }

  changeQnt(int type, int id) async {
    var cart = Provider.of<Cart>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await post(ApiHelper.api + 'changeQuantity', body: {
      'type': type.toString(),
      'product_id': id.toString()
    }, headers: {
      'Accept': 'application/json',
      'fcmToken': prefs.getString('fcm_token'),
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    cart.addItem(CartItem(
      productId: widget.fruit.id,
      product: Products(
          id: widget.fruit.id,
          name: widget.fruit.name,
          image: widget.fruit.image,
          inCart: widget.fruit.inCart,
          typeName: widget.fruit.typeName,
          type: widget.fruit.type,
          isFavorite: widget.fruit.inFavorite,
          priceOffer: widget.fruit.priceOffer,
          discount: widget.fruit.discount,
          price: widget.fruit.price.toDouble()),
      quantity: double.parse(response['Quantity'].toString()),
      fcmToken: prefs.getString('fcm_token'),
    ));
    if (response['status'] == true) {
      var items = response['cart'];
      if (items != null) {
        items.forEach((element) {
          CartItem item = CartItem.fromJson(element);
          cart.addItem(item);
        });
      }
    }
    print(response);
    if (response['message'] == 'product deleted') {
      cart.removeCartItem(id);
      MyAlert.addedToCart(1, context);
    }
  }

  Future setFav() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userToken') != null) {
      setState(() {
        widget.fruit.inFavorite = '1';
      });
      FavoriteOperations op =
          Provider.of<FavoriteOperations>(context, listen: false);
      var request =
          await get(ApiHelper.api + 'addFavorite/${widget.fruit.id}', headers: {
        'Accept': 'application/json',
        'Accept-Language': LangProvider().getLocaleCode(),
        'Authorization': 'Bearer ${prefs.getString('userToken')}'
      });
      var response = json.decode(request.body);
      // Fluttertoast.showToast(msg: response['message']);
      if (response['status'] == true) {
        setState(() {
          op.addItem(Products(
              id: widget.fruit.id,
              name: widget.fruit.name,
              image: widget.fruit.image,
              inCart: widget.fruit.inCart,
              typeName: widget.fruit.typeName,
              type: widget.fruit.type,
              isFavorite: widget.fruit.inFavorite,
              discount: widget.fruit.discount,
              price: widget.fruit.price.toDouble()));
          op.updateFavHome(Products(
              id: widget.fruit.id,
              name: widget.fruit.name,
              image: widget.fruit.image,
              inCart: widget.fruit.inCart,
              typeName: widget.fruit.typeName,
              type: widget.fruit.type,
              isFavorite: widget.fruit.inFavorite,
              discount: widget.fruit.discount,
              price: widget.fruit.price.toDouble()));
        });
      }
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => SignUpFirst(),
      );
    }
  }

  Future removeFav() async {
    FavoriteOperations op =
        Provider.of<FavoriteOperations>(context, listen: false);
    setState(() {
      widget.fruit.inFavorite = '0';
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await get(
        ApiHelper.api + 'deleteFromFavorit/${widget.fruit.id}',
        headers: {
          'Accept': 'application/json',
          'Accept-Language': LangProvider().getLocaleCode(),
          'Authorization': 'Bearer ${prefs.getString('userToken')}'
        });
    var response = json.decode(request.body);
    // Fluttertoast.showToast(msg: response['message']);
    if (response['status'] == true) {
      setState(() {
        op.removeFav(Products(
            id: widget.fruit.id,
            name: widget.fruit.name,
            image: widget.fruit.image,
            inCart: widget.fruit.inCart,
            typeName: widget.fruit.typeName,
            type: widget.fruit.type,
            isFavorite: widget.fruit.inFavorite,
            discount: widget.fruit.discount,
            price: widget.fruit.price.toDouble()));
        op.updateFavHome(Products(
            id: widget.fruit.id,
            name: widget.fruit.name,
            image: widget.fruit.image,
            inCart: widget.fruit.inCart,
            typeName: widget.fruit.typeName,
            discount: widget.fruit.discount,
            type: widget.fruit.type,
            isFavorite: widget.fruit.inFavorite,
            price: widget.fruit.price.toDouble()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var fav = Provider.of<FavoriteOperations>(context);
    final Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: LangProvider().getLocaleCode() == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Container(
            color: HexColor.fromHex(widget.fruit.specialFoodBg != ''
                ? widget.fruit.specialFoodBg
                : '#5ECC74'),
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                SafeArea(
                  child: Align(
                    alignment: LangProvider().getLocaleCode() == 'ar'
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 15, left: 15, top: 15),
                      child: CBackButton(),
                    ),
                  ),
                ),
                Expanded(
                  child: Hero(
                    tag: widget.fruit.image,
                    child: Image.network(
                      widget.fruit.image,
                      // height: size.width * 0.5,
                      // width: size.width * 0.5,
                      // fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                // SizedBox(height: 20),
                Expanded(
                  flex: widget.fruit.basketItem.length != 0 ? 2 : 1,
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
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
                          child: Row(
                            children: [
                              Text(
                                widget.fruit.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: CColors.headerText,
                                  fontSize: 20,
                                ),
                              ),
                              // SizedBox(width: 10),
                              // Text(
                              //   "${widget.fruit.qty} ${widget.fruit.typeName}",
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.w400,
                              //     color: CColors.headerText.withAlpha(150),
                              //     fontSize: 15,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.fruit.inCart != 0
                                ? Row(
                                    children: [
                                      CIconButton(
                                        onTap: () {
                                          setState(() {
                                            widget.fruit.inCart =
                                                widget.fruit.inCart -
                                                    widget.fruit.unitRate;
                                          });
                                          changeQnt(2, widget.fruit.id);
                                        },
                                        icon: Icon(Icons.remove,
                                            color: CColors.headerText,
                                            size: 25),
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: size.width * 0.12,
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.fruit.inCart % 1 == 0
                                                ? widget.fruit.inCart
                                                    .toStringAsFixed(0)
                                                : widget.fruit.inCart
                                                    .toString(),
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
                                          setState(widget.fruit.inCart != 0
                                              ? () {
                                                  widget.fruit.inCart =
                                                      widget.fruit.inCart +
                                                          widget.fruit.unitRate;
                                                }
                                              : () {});
                                          widget.fruit.inCart == 0
                                              ? addToBasket(widget.fruit.id)
                                              : changeQnt(1, widget.fruit.id);
                                        },
                                        icon: Icon(Icons.add,
                                            color: CColors.headerText,
                                            size: 25),
                                      ),
                                      // if (widget.fruit.minQty == 0)
                                      //   Text("add_to_basket".trs(context),
                                      //       style: TextStyle(
                                      //           fontSize: 13, color: CColors.grey)),
                                    ],
                                  )
                                : Container(),
                            Row(
                              children: [
                                Text(
                                  '${widget.fruit.discount > 0 && widget.fruit.priceOffer > 0 ? widget.fruit.price - (widget.fruit.price * widget.fruit.discount / 100) : widget.fruit.price % 1 == 0 ? widget.fruit.price.toStringAsFixed(0) : widget.fruit.price}',
                                  style: TextStyle(
                                    color: CColors.darkOrange,
                                    fontSize: 24,
                                  ),
                                ),
                                Text(
                                  "  ${'Q.R'.trs(context)}  ",
                                  style: TextStyle(
                                    color: CColors.darkOrange,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: size.width * .8,
                                    child: Text(
                                      widget.fruit.description ?? '',
                                      softWrap: true,
                                      style: TextStyle(
                                        color: CColors.normalText,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              widget.fruit.basketItem.length != 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: widget.fruit.basketItem.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return _BundleProduct(
                                          title: widget.fruit.basketItem[index]
                                              .item.name,
                                          imagePath: widget.fruit
                                              .basketItem[index].item.image,
                                          numOfItems: widget
                                              .fruit.basketItem[index].qty
                                              .toString(),
                                        );
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MakeFavoriteButton(
                              activeColor: CColors.lightGreen,
                              inActiveColor: CColors.lightGreen,
                              padding: EdgeInsets.all(10.0),
                              onValueChanged: () {
                                setState(() => _isFavorite = !_isFavorite);
                                if (widget.fruit.inFavorite == '1') {
                                  removeFav();
                                } else {
                                  setFav();
                                }
                              },
                              value:
                                  widget.fruit.inFavorite == '1' ? true : false,
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
                                                BoxConstraints(maxHeight: 45),
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

class _BundleProduct extends StatelessWidget {
  final String title;
  final String numOfItems;
  final String imagePath;

  const _BundleProduct({
    Key key,
    this.title,
    this.numOfItems,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.09,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: CColors.fadeGreen,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 80),
                  child: Row(
                    children: [
                      Text(
                        title ?? '',
                        style: TextStyle(
                          color: CColors.headerText,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "$numOfItems ${'items'.trs(context)}",
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xcc3c4959),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 10,
            child: Image.network(
              imagePath,
              width: 70,
              height: 70,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
