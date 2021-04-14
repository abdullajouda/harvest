import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/Wallet/wallet_amount_viewer.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../order_done.dart';

class PaymentMethod {
  final int id;
  final String title;
  final String iconPath;

  const PaymentMethod({
    this.id,
    this.title,
    this.iconPath,
  });
}

class BillingStep extends StatefulWidget {
  @override
  _BillingStepState createState() => _BillingStepState();
}

class _BillingStepState extends State<BillingStep> {
  int _chosenIndex = -1;
  bool load = false;
  double points;
  String balance;

  getWallet() async {
    setState(() {
      load = true;
    });
    var cart = Provider.of<Cart>(context,listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await get(ApiHelper.api + 'getWallet', headers: {
      'Accept': 'application/json',
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    setState(() {
      balance = response['balance'];
      cart.setWalletBalance(balance);
      points = double.parse(response['points'].toString());
      load = false;
    });
  }

  @override
  void initState() {
    getWallet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<PaymentMethod> _paymentMethods = [
      // PaymentMethod(title: "Bank Account", iconPath: 'assets/images/bank.svg'),
      PaymentMethod(title: "Cash".trs(context), iconPath: 'assets/images/cash.svg'),
      PaymentMethod(title: "card".trs(context), iconPath: 'assets/images/credit-card.svg'),
      // PaymentMethod(title: "PayPal", iconPath: 'assets/images/paypal.svg'),
    ];
    var cart = Provider.of<Cart>(context);
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "choose_payment_method".trs(context),
            style: TextStyle(
              color: CColors.headerText,
              fontSize: 15,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: CColors.white,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        offset: Offset(0, 5.0),
                        spreadRadius: 1,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "required_amount".trs(context) + "\t" * 2,
                          style: TextStyle(
                            color: CColors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "${'Q.R'.trs(context)} ",
                            style: TextStyle(
                              fontSize: 14,
                              color: CColors.darkOrange,
                            ),
                            children: [
                              TextSpan(
                                text: "${cart.totalPrice.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: CColors.headerText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                WalletAmount(
                    load: load, amount: balance, margin: EdgeInsets.zero),
                SizedBox(height: 5),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    // primary: false,
                    // physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    itemCount: _paymentMethods.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 135 / 137,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final _paymentMethod = _paymentMethods[index];
                      final _isSelected = _chosenIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _chosenIndex = index);
                          cart.setPaymentType(index);
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: CColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: _isSelected
                                ? Border.all(
                                    color: CColors.lightGreen, width: 2)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(5),
                                offset: Offset(0, 5.0),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(_paymentMethod.iconPath,
                                    width: 25, height: 25),
                                SizedBox(height: 10),
                                Text(
                                  _paymentMethod.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CColors.headerText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        // BasketPagesControlles(
        //   enableContinue: _chosenIndex != -1,
        // ),
      ],
    );
  }
}
