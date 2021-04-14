import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/widgets/Loader.dart';
import 'package:harvest/widgets/dialogs/alert_builder.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../directions.dart';

class OrderDescription extends StatefulWidget {
  final VoidCallback onTap;

  const OrderDescription({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  _OrderDescriptionState createState() => _OrderDescriptionState();
}

class _OrderDescriptionState extends State<OrderDescription> {
  TextEditingController _voucher;
  bool load = false;
  bool isValid = false;
  double _deliveryCost;
  double _total;
  double _discount;

  getDeliveryCost() async {
    setState(() {
      load = true;
    });
    var cart = Provider.of<Cart>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await get(
        ApiHelper.api + 'getDeliveryCost/${cart.deliveryAddresses.id}',
        headers: {
          'Accept': 'application/json',
          'fcmToken': prefs.getString('fcm_token'),
          'Authorization': 'Bearer ${prefs.getString('userToken')}',
          'Accept-Language': '${prefs.getString('language')}',
        });
    var response = json.decode(request.body);
    setState(() {
      _deliveryCost = double.parse(response.toString());
      // if(!cart.isFree){
      //   _deliveryCost = cart.deliveryAddresses.city.deliveryCost;
      // }
      _total = _deliveryCost + cart.total;
      load = false;
    });
  }

  checkPromo() async {
    if (_voucher.text != '') {
      setState(() {
        load = true;
      });
      var cart = Provider.of<Cart>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var request = await get(
          ApiHelper.api + 'checkPromo?name=${_voucher.text}',
          headers: {
            'Accept': 'application/json',
            'Accept-Language': '${prefs.getString('language')}',
          });
      var response = json.decode(request.body);
      print(response);
      if (response['status'] == true) {
        cart.setPromo(_voucher.text);
        setState(() {
          _discount =
              double.parse(response['PromotionCode']['discount'].toString());
          isValid = true;
        });
        print(_discount);
      } else {
        showGeneralDialog(
          barrierDismissible: true,
          barrierLabel: '',
          barrierColor: Colors.black.withOpacity(0.1),
          transitionDuration: Duration(milliseconds: 400),
          context: context,
          pageBuilder: (context, anim1, anim2) {
            return GestureDetector(
              onTap: () => Navigator.pop(context),
              child: AlertBuilder(
                title: 'Promotion code not Valid'.trs(context),
                subTitle: '',
                color: CColors.coldPaleBloodRed,
                icon: Icon(
                  Icons.warning_amber_rounded,
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
      }
    } else {
      Fluttertoast.showToast(msg: 'Provide Voucher Code');
    }

    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    _voucher = TextEditingController();
    getDeliveryCost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var cart = Provider.of<Cart>(context);
    final List<Widget> _options = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "bill_total".trs(context),
            style: TextStyle(
              fontSize: 15,
              color: CColors.headerText,
            ),
          ),
          Text(
            "${cart.total.toStringAsFixed(2)} ${'Q.R'.trs(context)}",
            style: TextStyle(
              fontSize: 14,
              color: CColors.headerText,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "delivery_charge".trs(context),
            style: TextStyle(
              fontSize: 15,
              color: CColors.headerText,
            ),
          ),
          _deliveryCost != null
              ? Text(
                  "${_deliveryCost.toStringAsFixed(1)} ${'Q.R'.trs(context)}",
                  style: TextStyle(
                    fontSize: 12,
                    color: CColors.headerText,
                  ),
                )
              : Container(),
        ],
      ),
      _buildVoucherField(context, size),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "total".trs(context),
            style: TextStyle(
              fontSize: 15,
              color: CColors.headerText,
              fontWeight: FontWeight.w600,
            ),
          ),
          load
              ? Container()
              : Row(
                  children: [
                    Text(
                      "${(cart.total.toDouble() + _deliveryCost.toDouble()).toStringAsFixed(2)} ${'Q.R'.trs(context)}",
                      style: TextStyle(
                          fontSize: _discount != null ? 12 : 15,
                          color: _discount != null
                              ? CColors.darkOrange
                              : CColors.headerText,
                          decoration: _discount != null
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                    _discount != null
                        ? Text(
                            "${((_total) - (_total * _discount / 100)).toStringAsFixed(2)} ${'Q.R'.trs(context)}",
                            style: TextStyle(
                              fontSize: 15,
                              color: CColors.headerText,
                            ),
                          )
                        : Container(),
                  ],
                ),
        ],
      ),
    ];
    return Direction(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
            color: const Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                color: const Color(0x1c000000),
                offset: Offset(0, -17),
                blurRadius: 24,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Card(
                  elevation: 0.0,
                  color: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99)),
                  child: SizedBox(width: size.width * 0.35, height: 6),
                ),
              ),
              Text(
                "order_description".trs(context),
                style: TextStyle(
                  fontSize: 18,
                  color: CColors.headerText,
                ),
              ),
              load
                  ? Loader()
                  : ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _options.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: _options[index]),
                    ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: FlatButton(
                  onPressed: () {
                    cart.setTotalPrice(_discount != null
                        ? (_total) - (_total * _discount / 100)
                        : _total);
                    widget.onTap.call();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: CColors.lightGreen,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "continue".trs(context),
                      style: TextStyle(
                        color: CColors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
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

  Widget _buildVoucherField(BuildContext context, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "voucher".trs(context),
            style: TextStyle(
              fontSize: 15,
              color: CColors.headerText,
            ),
          ),
        ),
        if (isValid == false)
          Expanded(
            child: SizedBox(
              height: size.height * 0.05,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsetsDirectional.only(
                            start: 10, top: 9, bottom: 9),
                        hintStyle: TextStyle(fontSize: 12),
                        hintText: "code".trs(context),
                        border: _buildVoucherTextFieldBorder(),
                        focusedBorder: _buildVoucherTextFieldBorder(),
                        enabledBorder: _buildVoucherTextFieldBorder(),
                      ),
                      controller: _voucher,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        checkPromo();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: CColors.darkOrange,
                      child: Text(
                        "apply".trs(context),
                        style: TextStyle(
                          fontSize: 12,
                          color: CColors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          GestureDetector(
            onTap: () => setState(() {
              isValid = false;
              _discount = null;
            }),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999)),
              color: CColors.fadeBlue,
              margin: EdgeInsets.zero,
              elevation: 0.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: CColors.white, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(Icons.close, size: 12),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "#${_voucher.text}",
                      style: TextStyle(
                        color: CColors.headerText,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  ShapeBorder _buildVoucherTextFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.grey[300], width: 1),
    );
  }
}
