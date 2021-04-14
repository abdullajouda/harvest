import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/customer/views/home/main_product.dart';
import 'package:harvest/helpers/Localization/lang_provider.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:harvest/widgets/alerts/myAlerts.dart';
import 'package:harvest/widgets/favorite_button.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harvest/helpers/Localization/localization.dart';

class FruitItem extends StatefulWidget {
  final Products fruit;
  final Color color;

  const FruitItem({Key key, this.fruit, this.color}) : super(key: key);

  @override
  _FruitItemState createState() => _FruitItemState();
}

class _FruitItemState extends State<FruitItem> {
  bool load = false;

  addToBasket(int id) async {
    setState(() {
      widget.fruit.inCart = widget.fruit.inCart + widget.fruit.unitRate;
    });
    var cart = Provider.of<Cart>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await post(ApiHelper.api + 'addProductToCart/$id', headers: {
      'Accept': 'application/json',
      'fcmToken': prefs.getString('fcm_token'),
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    if (response['status'] == true) {
      MyAlert.addedToCart(0, context);
      var items = response['cart'];
      if (items != null) {
        cart.clearFav();
        items.forEach((element) {
          CartItem item = CartItem.fromJson(element);
          cart.addItem(item);
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
    if (response['message'] == 'product deleted') {
      cart.removeCartItem(widget.fruit.id);
      MyAlert.addedToCart(1, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LangProvider>(context);
    return widget.fruit.qty == 0
        ? Container(
            height: 160,
            width: 160,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 84,
                        width: 87,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.fruit.image,
                            ),
                            fit: BoxFit.fill,
                          ),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: const Color(0x0f000000),
                          //     offset: Offset(0, 6),
                          //     blurRadius: 8,
                          //   ),
                          // ],
                        ),
                      ),
                      Text(
                        widget.fruit.name ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xff3c4959),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Sold Out'.trs(context),
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xff3c4959),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white38,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x17000000),
                        offset: Offset(0, 10),
                        blurRadius: 21,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        : widget.fruit.havePrice == 2
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(
                    builder: (context) => MainProduct(
                      offers: widget.fruit,
                      color: widget.fruit.color,
                    ),
                  ));
                },
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: const Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x17000000),
                        offset: Offset(0, 10),
                        blurRadius: 21,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 84,
                              width: 87,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    widget.fruit.image,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: const Color(0x0f000000),
                                //     offset: Offset(0, 6),
                                //     blurRadius: 8,
                                //   ),
                                // ],
                              ),
                            ),
                            Text(
                              widget.fruit.name ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xff3c4959),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: const Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x17000000),
                      offset: Offset(0, 10),
                      blurRadius: 21,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 3,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: widget.fruit.inCart != 0 ? 64 : 84,
                        width: widget.fruit.inCart != 0 ? 68 : 87,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.fruit.image),
                            fit: BoxFit.fill,
                          ),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: const Color(0x0f000000),
                          //     offset: Offset(0, 6),
                          //     blurRadius: 8,
                          //   ),
                          // ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: FavoriteButton(
                        fruit: widget.fruit,
                      ),
                    ),
                    widget.fruit.discount > 0 && widget.fruit.priceOffer > 0
                        ? Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              height: 22,
                              width: 53,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                                color: const Color(0xfff88518),
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.fruit.discount}% ${'Off'.trs(context)}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: const Color(0xffffffff),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Positioned(
                      left: lang.getLocaleCode() == 'ar' ? null : 20,
                      right: lang.getLocaleCode() == 'ar' ? 30 : null,
                      bottom: widget.fruit.inCart != 0
                          ? 40
                          : lang.getLocaleCode() == 'ar'
                              ? 23
                              : 13,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.fruit.name ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xff3c4959),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          widget.fruit.description != null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 90),
                                    child: Text(
                                      widget.fruit.description,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: const Color(0xffe3e7eb),
                                        fontWeight: FontWeight.w300,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                )
                              : Container(),
                          Row(
                            children: [
                              Text(
                                '${widget.fruit.discount > 0 && widget.fruit.priceOffer > 0 ? widget.fruit.price - (widget.fruit.price * widget.fruit.discount / 100) : widget.fruit.price % 1 == 0 ? widget.fruit.price.toStringAsFixed(0) : widget.fruit.price}  ${'Q.R'.trs(context)}/${widget.fruit.typeName}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: widget.color != null
                                      ? widget.color
                                      : const Color(0xff3c984f),
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              widget.fruit.discount > 0 &&
                                      widget.fruit.priceOffer > 0
                                  ? Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Text(
                                          '  ${widget.fruit.price.toStringAsFixed(0)}  ',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: widget.color != null
                                                ? widget.color
                                                : const Color(0xff3c984f),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        SvgPicture.asset('assets/line.svg',color: widget.color != null
                                            ? widget.color
                                            : const Color(0xff3c984f),)
                                      ],
                                    )
                                  : Container(),
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(widget.fruit.inCart != 0
                              ? () {
                                  widget.fruit.inCart = widget.fruit.inCart +
                                      widget.fruit.unitRate;
                                }
                              : () {});
                          widget.fruit.inCart == 0
                              ? addToBasket(widget.fruit.id)
                              : changeQnt(1, widget.fruit.id);
                        },
                        child: Container(
                          height: 31,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(19.0),
                              bottomRight: Radius.circular(19.0),
                            ),
                            color: widget.color != null
                                ? widget.color
                                : Color(0xff3c984f),
                          ),
                          child: Center(
                            child: load
                                ? SpinKitFadingCircle(
                                    color: CColors.white,
                                    size: 15,
                                  )
                                : SvgPicture.asset('assets/icons/add.svg'),
                          ),
                        ),
                      ),
                    ),
                    widget.fruit.inCart != 0
                        ? Positioned(
                            bottom: 7,
                            child: load
                                ? SpinKitFadingCircle(
                                    color: CColors.darkGreen,
                                    size: 15,
                                  )
                                : Text(
                                    '${widget.fruit.inCart % 1 == 0 ? widget.fruit.inCart.toStringAsFixed(0) :widget.fruit.inCart}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color(0xff3c4959),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                          )
                        : Container(),
                    widget.fruit.inCart != 0
                        ? Positioned(
                            bottom: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.fruit.inCart = widget.fruit.inCart -
                                      widget.fruit.unitRate;
                                });
                                changeQnt(2, widget.fruit.id);
                              },
                              child: Container(
                                height: 31,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(19.0),
                                    bottomLeft: Radius.circular(19.0),
                                  ),
                                  color: const Color(0xffe3e7eb),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                      'assets/icons/remove.svg'),
                                ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              );
  }
}
