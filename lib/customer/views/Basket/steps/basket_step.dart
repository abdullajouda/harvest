import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/Widgets/remove_icon.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/city.dart';
import 'package:harvest/customer/models/delivery-data.dart';
import 'package:harvest/customer/models/error.dart';
import 'package:harvest/customer/models/user.dart';
import 'package:harvest/customer/views/Basket/free_shipping_slider.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/Profile/user_profile.dart';
import 'package:harvest/customer/widgets/custom_icon_button.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/widgets/add_new_address_dialog.dart';
import 'package:harvest/widgets/alerts/myAlerts.dart';
import 'package:harvest/widgets/dialogs/alert_builder.dart';
import 'package:harvest/widgets/dialogs/minimun_charge.dart';
import 'package:harvest/widgets/dialogs/signup_dialog.dart';
import 'package:harvest/widgets/directions.dart';
import 'package:harvest/widgets/my_animation.dart';
import 'package:harvest/widgets/no_data.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasketStep extends StatefulWidget {
  final VoidCallback onContinuePressed;
  final VoidCallback onErrorFound;

  const BasketStep({
    Key key,
    this.onContinuePressed,
    this.onErrorFound,
  }) : super(key: key);

  @override
  _BasketStepState createState() => _BasketStepState();
}

class _BasketStepState extends State<BasketStep> {
  bool load = true;
  bool showFree = false;
  bool loadRemaining = true;
  bool isAuth = false;

  double total;
  double deliveryCost;
  double minOrder;
  double remains;

  List<DeliveryAddresses> addresses = [];
  DeliveryAddresses _selected;
  TextEditingController _textEditingController;
  double _textFieldHeight = 0;
  final double _finalValue = 100.0;

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userToken') != null) {
      setState(() {
        isAuth = true;
      });
      showFreeDelivery();
    }
  }

  // Future getAddresses() async {
  //   setState(() {
  //     addresses = [];
  //     // load = true;
  //   });
  //   var cart = Provider.of<Cart>(context, listen: false);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var request = await get(ApiHelper.api + 'allAddressForUser', headers: {
  //     'Accept': 'application/json',
  //     'Accept-Language': '${prefs.getString('language')}',
  //     'Authorization': 'Bearer ${prefs.getString('userToken')}'
  //   });
  //   var response = json.decode(request.body);
  //   List locations = response['items'];
  //   locations.forEach((element) {
  //     DeliveryAddresses deliveryAddress = DeliveryAddresses.fromJson(element);
  //     addresses.add(deliveryAddress);
  //   });
  //   setState(() {
  //     _selected = addresses[0];
  //     cart.setAddress(_selected);
  //     load = false;
  //   });
  // }
  checkCartItems() async {
    if (isAuth) {
      setState(() {
        load = true;
      });
      var cart = Provider.of<Cart>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var request = await post(ApiHelper.api + 'checkCart', body: {
        'delivery_address': _selected.id.toString(),
      }, headers: {
        'Accept': 'application/json',
        'fcmToken': prefs.getString('fcm_token'),
        'Accept-Language': LangProvider().getLocaleCode(),
        'Authorization': 'Bearer ${prefs.getString('userToken')}'
      });
      var response = json.decode(request.body);
      print(response);
      if (response['code'] == 200) {
        if (_textEditingController.text != null) {
          cart.setAdditional(_textEditingController.text);
        }
        cart.setTotal(total);
        showNextDialog();
      } else if (response['code'] == 204) {
        showCupertinoDialog(
          context: context,
          builder: (context) => MinimumChargeDialog(
            subTitle: response['message'],
          ),
        );
      } else if (response['code'] == 205) {
        var list = response['items'];
        // cart.addError(index);
        list.forEach((element) {
          ErrorModel model = ErrorModel.fromJson(element);
          cart.addError(model);
          // cart.addError(int.parse(element.toString()));
        });
        widget.onErrorFound.call();
      }
      setState(() {
        load = false;
      });
    } else {
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => SignUpDialog(),
      );
    }
  }

  Future getCart() async {
    // setState(() {
    //   load = true;
    // });
    var cart = Provider.of<Cart>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await get(ApiHelper.api + 'getMyCart', headers: {
      'Accept': 'application/json',
      'fcmToken': prefs.getString('fcm_token'),
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });

    var response = json.decode(request.body);
    var items = response['items'];
    setState(() {
      total = double.parse(response['total']);
    });
    cart.clearFav();
    for (int i = 0; i < items.length; i++) {
      print(items[i]);
      CartItem item = CartItem.fromJson(items[i]);
      cart.addItem(item);
      if (item.quantity > item.product.qty) {
        cart.addError(
            ErrorModel(id: item.product.id, remain: item.product.qty));
      }
    }
    // items.forEach((element) {
    //   CartItem item = CartItem.fromJson(element);
    //   cart.addItem(item);
    //   if (item.quantity > item.product.available) {
    //     _errorIndexes.add(value);
    //   }
    // });
    if (isAuth) {
      getDefault();
    }
    setState(() {
      load = false;
    });
  }

  changeQnt(int type, int id) async {
    // setState(() {
    //   load = true;
    // });
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
    if (response['status'] == true) {
      setState(() {
        total = double.parse(response['total'].toString());
      });
    }
    if (response['message'] == 'product deleted') {
      MyAlert.addedToCart(1, context);
    }
    setState(() {
      getRemains();
      load = false;
    });
  }

  removeFromCart(CartItem item) async {
    var cart = Provider.of<Cart>(context, listen: false);
    cart.removeCartItem(item.productId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await get(
        ApiHelper.api + 'deleteProductCart/${item.productId}',
        headers: {
          'Accept': 'application/json',
          'fcmToken': prefs.getString('fcm_token'),
          'Accept-Language': LangProvider().getLocaleCode(),
          'Authorization': 'Bearer ${prefs.getString('userToken')}'
        });
    var response = json.decode(request.body);
    print(response);
    if (response['status'] == true) {
      MyAlert.addedToCart(1, context);
      getCart();
    }
    setState(() {
      total = response['total_cart'];
    });
  }

  showFreeDelivery() async {
    var settings = await get(ApiHelper.api + 'getSetting', headers: {
      'Accept': 'application/json',
      'Accept-Language': LangProvider().getLocaleCode(),
    });
    var set = json.decode(settings.body)['items'];
    if (set['show_delivery_free_msg'] == 1) {
      setState(() {
        showFree = true;
      });
    }
  }

  Future getDefault() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      minOrder = prefs.getDouble('minOrder');
      deliveryCost = prefs.getDouble('deliveryCost');
      getRemains();
      _selected = DeliveryAddresses(
        id: prefs.getInt('deliveryAddressId'),
        address: prefs.getString('address'),
        buildingNumber: prefs.getInt('buildingNumber'),
        city: City(
          name: prefs.getString('city'),
          deliveryCost: prefs.getDouble('deliveryCost'),
          minOrder: prefs.getDouble('minOrder'),
        ),
        lat: prefs.getDouble('lat'),
        lan: prefs.getDouble('lng'),
        unitNumber: prefs.getInt('unitNumber'),
      );
    });
  }

  Future getRemains() async {
    setState(() {
      remains =
          double.parse(minOrder.toString()) - double.parse(total.toString());
      loadRemaining = false;
    });
  }

  @override
  void initState() {
    remains = 1;
    _textEditingController = TextEditingController();
    checkToken();
    getCart();
    // getDefault();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  void _toggleTextFieldHeight() {
    if (_textFieldHeight == _finalValue)
      _textFieldHeight = 0;
    else
      _textFieldHeight = _finalValue;
  }

  showNextDialog() {
    var cart = Provider.of<Cart>(context, listen: false);
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) => _AddressConfirmationDialog(
        address: _selected,
        onTapContinue: () {
          cart.setAddress(_selected);
          cart.setIsFree(remains <= 0);
          Navigator.pop(context);
          widget.onContinuePressed.call();
        },
        onTapNewOne: () => Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(
            builder: (context) => UserProfile(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "in_basket_now".trs(context),
            style: TextStyle(
              color: CColors.headerText,
              fontSize: 15,
            ),
          ),
        ),
        SizedBox(height: 5),
        Expanded(
          child: load ? Center(child: LoadingPhone()) : _buildItemsBody(size),
        ),
      ],
    );
  }

  ListView _buildItemsBody(Size size) {
    var cart = Provider.of<Cart>(context);

    return cart.items.length == 0
        ? ListView(
            children: [NoData()],
          )
        : ListView.separated(
            itemCount: cart.items.length,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            separatorBuilder: (context, index) {
              // final _hasError = _itemHasError(cart.items.values.toList()[index]);
              // if (_hasError) return SizedBox(height: 5);
              return SizedBox(height: 25);
            },
            itemBuilder: (context, index) {
              bool _itemHasError(CartItem cartItem) {
                if (cart.errors.containsKey(cartItem.productId.toString())) {
                  return true;
                } else {
                  return false;
                }
                // if (cart.errors.keys.toList().contains(cartItem.productId)) return true;
                // return false;
              }

              final bool _hasError =
                  _itemHasError(cart.items.values.toList()[index]);
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          if (cart.items.values.toList()[index].product.qty <
                              cart.items.values.toList()[index].quantity) {
                            cart.addError(ErrorModel(
                                id: cart.items.values.toList()[index].productId,
                                remain: cart.items.values
                                    .toList()[index]
                                    .product
                                    .qty));
                            // cart.addError(index);
                          } else {
                            cart.errors.removeWhere((key, value) =>
                                key.toString() ==
                                cart.items.values
                                    .toList()[index]
                                    .productId
                                    .toString());
                          }
                        },
                      );
                    },
                    child: Column(
                      children: [
                        if (_hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Align(
                              alignment: AlignmentDirectional(-0.8, 0.0),
                              child: _buildRemainingItemsCard(
                                  context,
                                  index,
                                  cart.errors.values.toList().firstWhere(
                                      (element) =>
                                          element.id.toString() ==
                                          cart.items.values
                                              .toList()[index]
                                              .productId
                                              .toString())),
                            ),
                          ),
                        Container(
                          height: 100,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: RemoveIcon(
                                  onTap: () {
                                    removeFromCart(
                                        cart.items.values.toList()[index]);
                                  },
                                  iconAlignment: Alignment.topRight,
                                  deocation: RemoveIconDecoration.copyWith(
                                    iconColor: CColors.headerText,
                                    iconSize: 20,
                                    backgroundColor: CColors.white,
                                    borderColor: _hasError
                                        ? CColors.coldPaleBloodRed
                                        : CColors.white,
                                    borderWidth: 2,
                                    elevation: 1,
                                    raduis: 2,
                                  ),
                                  shadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(15),
                                      offset: Offset(0, 5.0),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                    ),
                                  ],
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(
                                        color: _hasError
                                            ? CColors.coldPaleBloodRed
                                            : CColors.transparent,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(10),
                                          offset: Offset(0, 5.0),
                                          spreadRadius: 1,
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      leading: Image.network(
                                          cart.items.values
                                              .toList()[index]
                                              .product
                                              .image,
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover),
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              cart.items.values
                                                  .toList()[index]
                                                  .product
                                                  .name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: const Color(0xff3c984f),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            ConstrainedBox(
                                              constraints: BoxConstraints(maxHeight: 12,),
                                              child: Text(
                                                cart.items.values
                                                        .toList()[index]
                                                        .product
                                                        .description ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: const Color(0xff888a8d),
                                                ),overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 70,
                                                child: cart.items.values
                                                                .toList()[index]
                                                                .product
                                                                .discount >
                                                            0 &&
                                                        cart.items.values
                                                                .toList()[index]
                                                                .product
                                                                .priceOffer >
                                                            0
                                                    ? Text(
                                                        "${(cart.items.values.toList()[index].product.price - (cart.items.values.toList()[index].product.price * cart.items.values.toList()[index].product.discount / 100))}  ${"Q.R".trs(context)}/${cart.items.values.toList()[index].product.typeName}",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: const Color(
                                                              0xff3c984f),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      )
                                                    : Text(
                                                        "${cart.items.values.toList()[index].product.price}  ${"Q.R".trs(context)}/${cart.items.values.toList()[index].product.typeName}",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: const Color(
                                                              0xff3c984f),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                              ),
                                              SizedBox(width: 3),
                                              CIconButton(
                                                onTap: () {
                                                  if (cart.items.values
                                                          .toList()[index]
                                                          .quantity !=
                                                      1) {
                                                    setState(() {
                                                      cart.items.values
                                                          .toList()[index]
                                                          .quantity = cart
                                                              .items.values
                                                              .toList()[index]
                                                              .quantity -
                                                          cart.items.values
                                                              .toList()[index]
                                                              .product
                                                              .unitRate;

                                                      if (cart.items.values
                                                              .toList()[index]
                                                              .product
                                                              .qty <
                                                          cart.items.values
                                                              .toList()[index]
                                                              .quantity) {
                                                        cart.addError(
                                                            ErrorModel(
                                                                id: cart.items
                                                                    .values
                                                                    .toList()[
                                                                        index]
                                                                    .productId,
                                                                remain: cart
                                                                    .items
                                                                    .values
                                                                    .toList()[
                                                                        index]
                                                                    .product
                                                                    .qty));
                                                        // cart.addError(index);
                                                      } else {
                                                        cart.errors.removeWhere(
                                                            (key, value) =>
                                                                key.toString() ==
                                                                cart.items
                                                                    .values
                                                                    .toList()[
                                                                        index]
                                                                    .productId
                                                                    .toString());
                                                      }
                                                    });
                                                    changeQnt(
                                                        2,
                                                        cart.items.values
                                                            .toList()[index]
                                                            .productId);
                                                  }
                                                },
                                                color: CColors.darkOrange,
                                                icon: Icon(Icons.remove,
                                                    color: CColors.white,
                                                    size: 15),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2),
                                                child: Text(
                                                  "${cart.items.values.toList()[index].quantity % 1 == 0 ? cart.items.values.toList()[index].quantity.toStringAsFixed(0) :cart.items.values.toList()[index].quantity}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: CColors.headerText,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              CIconButton(
                                                onTap: () {
                                                  setState(() {
                                                    cart.items.values
                                                        .toList()[index]
                                                        .quantity = cart
                                                            .items.values
                                                            .toList()[index]
                                                            .quantity +
                                                        cart.items.values
                                                            .toList()[index]
                                                            .product
                                                            .unitRate;
                                                    if (cart.items.values
                                                            .toList()[index]
                                                            .product
                                                            .qty <
                                                        cart.items.values
                                                            .toList()[index]
                                                            .quantity) {
                                                      cart.addError(ErrorModel(
                                                          id: cart.items.values
                                                              .toList()[index]
                                                              .productId,
                                                          remain: cart
                                                              .items.values
                                                              .toList()[index]
                                                              .product
                                                              .qty));
                                                      // cart.addError(index);
                                                    } else {
                                                      cart.errors.removeWhere(
                                                          (key, value) =>
                                                              key.toString() ==
                                                              cart.items.values
                                                                  .toList()[
                                                                      index]
                                                                  .productId
                                                                  .toString());
                                                    }
                                                  });
                                                  changeQnt(
                                                      1,
                                                      cart.items.values
                                                          .toList()[index]
                                                          .productId);
                                                },
                                                color: CColors.darkOrange,
                                                icon: Icon(Icons.add,
                                                    color: CColors.white,
                                                    size: 15),
                                              ),
                                            ],
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              text: "Q.R".trs(context),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: const Color(0xfff88518),
                                                fontWeight: FontWeight.w600,
                                              ),
                                              children: [
                                                cart.items.values
                                                                .toList()[index]
                                                                .product
                                                                .discount >
                                                            0 &&
                                                        cart.items.values
                                                                .toList()[index]
                                                                .product
                                                                .priceOffer >
                                                            0
                                                    ? TextSpan(
                                                        text:
                                                            " ${(cart.items.values.toList()[index].quantity * (cart.items.values.toList()[index].product.price - (cart.items.values.toList()[index].product.price * cart.items.values.toList()[index].product.discount / 100))).toStringAsFixed(1)}",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: const Color(
                                                              0xff3c4959),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )
                                                    : TextSpan(
                                                        text:
                                                            " ${cart.items.values.toList()[index].quantity * cart.items.values.toList()[index].product.price}",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: const Color(
                                                              0xff3c4959),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment:
                                    LangProvider().getLocaleCode() == 'ar'
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    removeFromCart(
                                        cart.items.values.toList()[index]);
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  index == cart.items.length - 1
                      ? Column(
                          children: [
                            SizedBox(height: 40),
                            Align(
                              alignment: AlignmentDirectional(-.8, 0.0),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: InkWell(
                                        onTap: () =>
                                            setState(_toggleTextFieldHeight),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: CColors.headerText,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Icon(
                                                    _isNormalNotesHeight
                                                        ? Icons.remove
                                                        : Icons.add,
                                                    color: CColors.white,
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 7),
                                              Text(
                                                "additional_note".trs(context),
                                                style: TextStyle(
                                                  color: CColors.headerText,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          height: _textFieldHeight,
                                          decoration: BoxDecoration(
                                            color: CColors.brightLight,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: TextField(
                                            controller: _textEditingController,
                                            maxLines: 4,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              focusColor: CColors.brightLight,
                                              fillColor: CColors.brightLight,
                                              contentPadding:
                                                  EdgeInsetsDirectional.only(
                                                      start: 10,
                                                      top: 9,
                                                      bottom: 9),
                                              hintStyle:
                                                  TextStyle(fontSize: 12),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide.none,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            right: 6,
                                            bottom: 6,
                                            child: SvgPicture.asset(
                                                'assets/icons/additional_icon.svg'))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 46, horizontal: 30),
                              child: Column(
                                children: [
                                  Container(
                                    child: showFree
                                        ? loadRemaining
                                            ? Container()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      remains > 0.0
                                                          ? Card(
                                                              color: CColors
                                                                  .darkOrange,
                                                              elevation: 0.0,
                                                              margin: EdgeInsets
                                                                  .zero,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadiusDirectional
                                                                        .only(
                                                                  bottomEnd: Radius
                                                                      .circular(
                                                                          13),
                                                                  topStart: Radius
                                                                      .circular(
                                                                          13),
                                                                  topEnd: Radius
                                                                      .circular(
                                                                          13),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          5),
                                                                  child: Text(
                                                                    "${remains.toStringAsFixed(2)} ${"Q.R".trs(context)} ",
                                                                    style: TextStyle(
                                                                        color: CColors
                                                                            .white),
                                                                  )),
                                                            )
                                                          : Container(),
                                                      SizedBox(width: 5),
                                                      remains > 0.0
                                                          ? Text(
                                                              "remains_for_free_shipping"
                                                                  .trs(context),
                                                              style: TextStyle(
                                                                color: CColors
                                                                    .grey,
                                                                fontSize: 13,
                                                              ),
                                                            )
                                                          : Text(
                                                              'you_have_free_shipping'
                                                                  .trs(context),
                                                              style: TextStyle(
                                                                color: CColors
                                                                    .grey,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: FreeShippingSlider(
                                                      minOrder: minOrder,
                                                      persentage: remains > 0.0
                                                          ? remains / minOrder
                                                          : 0.0,
                                                    ),
                                                  )
                                                ],
                                              )
                                        : Container(),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: const Color(0xffffffff),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x14000000),
                                          offset: Offset(0, 6),
                                          blurRadius: 21,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 15),
                                          child: Row(
                                            children: [
                                              Text(
                                                "total".trs(context) + "\t" * 2,
                                                style: TextStyle(
                                                  color: CColors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  text: "Q.R".trs(context),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: CColors.darkOrange,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: " ${total.toStringAsFixed(1)} ",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            CColors.headerText,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            checkCartItems();
                                            // if (cart.errors.length == 0) {
                                            //
                                            //   showNextDialog();
                                            // }
                                            // else {
                                            //   showGeneralDialog(
                                            //     barrierDismissible: true,
                                            //     barrierLabel: '',
                                            //     barrierColor: Colors.black
                                            //         .withOpacity(0.1),
                                            //     transitionDuration:
                                            //         Duration(milliseconds: 400),
                                            //     context: context,
                                            //     pageBuilder:
                                            //         (context, anim1, anim2) {
                                            //       return GestureDetector(
                                            //         onTap: () =>
                                            //             Navigator.pop(context),
                                            //         child: AlertBuilder(
                                            //           title:
                                            //               'The Highlighted items not available'
                                            //                   .trs(context),
                                            //           subTitle:
                                            //               'Try to remove or adjust the number of this items'
                                            //                   .trs(context),
                                            //           color: CColors
                                            //               .coldPaleBloodRed,
                                            //           icon: Icon(
                                            //             Icons
                                            //                 .warning_amber_rounded,
                                            //             color: CColors.white,
                                            //           ),
                                            //         ),
                                            //       );
                                            //     },
                                            //     transitionBuilder: (context,
                                            //         anim1, anim2, child) {
                                            //       return SlideTransition(
                                            //         position: Tween(
                                            //                 begin:
                                            //                     Offset(0, -1),
                                            //                 end: Offset(0, 0))
                                            //             .animate(anim1),
                                            //         child: child,
                                            //       );
                                            //     },
                                            //   );
                                            // }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: CColors.lightGreen,
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      Colors.black.withAlpha(5),
                                                  offset: Offset(0, 5.0),
                                                  spreadRadius: 1,
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 13),
                                              child: Text(
                                                "continue".trs(context),
                                                style: TextStyle(
                                                  color: CColors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              );
            },
          );
  }

  bool _isAddressSelected(DeliveryAddresses index) => _selected == index;

  Widget _buildRemainingItemsCard(
      BuildContext context, index, ErrorModel cart) {
    return Card(
      color: CColors.coldPaleBloodRed,
      elevation: 0.0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(11.5))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          "${cart.remain}\t" + "item_remains".trs(context),
          style: TextStyle(
            color: CColors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  bool get _isNormalNotesHeight => _textFieldHeight == _finalValue;
}

class _AddressConfirmationDialog extends StatelessWidget {
  final VoidCallback onTapContinue;
  final VoidCallback onTapNewOne;
  final DeliveryAddresses address;

  const _AddressConfirmationDialog({
    Key key,
    this.onTapContinue,
    this.onTapNewOne,
    this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Direction(
      child: Dialog(
        backgroundColor: CColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "order_will_be_delivered_to".trs(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: CColors.headerText,
                ),
              ),
              SizedBox(height: 10),
              Container(
                constraints: BoxConstraints(
                  maxHeight: 150,
                  maxWidth: size.width * 0.6,
                ),
                decoration: BoxDecoration(
                  color: CColors.lightOrange,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  leading:
                      SvgPicture.asset(Constants.mapPin, width: 40, height: 40),
                  title: Text(
                    "${address.city.name}, ${address.address}",
                    style: TextStyle(
                      fontSize: 13,
                      color: CColors.headerText,
                    ),
                  ),
                  subtitle: Text(
                    "${address.buildingNumber}, ${address.unitNumber}",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "or_add_new_adress".trs(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CColors.grey,
                    fontSize: 11,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (onTapNewOne != null) onTapNewOne();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: CColors.lightGreen, width: 2),
                    ),
                    color: CColors.transparent,
                    child: Text(
                      "new_one_address".trs(context),
                      style: TextStyle(
                        color: CColors.lightGreen,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  FlatButton(
                    onPressed: onTapContinue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: Colors.grey[200],
                    child: Text(
                      "continue".trs(context),
                      style: TextStyle(
                        color: CColors.lightGreen,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
