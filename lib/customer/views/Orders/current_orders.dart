import 'dart:convert';
import 'dart:math';
import 'package:harvest/helpers/Localization/lang_provider.dart';
import 'package:harvest/widgets/not_authenticated.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harvest/customer/models/orders.dart';
import 'package:harvest/customer/widgets/Orders/order_details_panel.dart';
import 'package:harvest/customer/widgets/Orders/order_current_list_tile.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/Loader.dart';
import 'package:harvest/widgets/dialogs/signup_first.dart';
import 'package:harvest/widgets/no_data.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentOrders extends StatefulWidget {
  @override
  _CurrentOrdersState createState() => _CurrentOrdersState();
}

class _CurrentOrdersState extends State<CurrentOrders> {
  bool loadOrders = true;
  List<Order> _orders = [];

  getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userToken') != null) {
      setState(() {
        loadOrders = true;
      });
      var request =
          await get(ApiHelper.api + 'getMyOrdersByStatus/1', headers: {
        'Accept': 'application/json',
        'Accept-Language': LangProvider().getLocaleCode(),
        'Authorization': 'Bearer ${prefs.getString('userToken')}'
      });
      var response = json.decode(request.body);
      List values = response['items'];
      values.forEach((element) {
        Order orders = Order.fromJson(element);
        _orders.add(orders);
      });
      setState(() {
        loadOrders = false;
      });
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => SignUpFirst(),
      );
    }
  }

  _showButtonPanel(Order order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) => OrderDetailsPanel(
        order: order, status: 1,
      ),
    );
  }

  @override
  void initState() {
    isAuth();
    getOrders();
    super.initState();
  }

  Color backGroundColor(Order order) {
    switch (order.status) {
      case 1:
        return CColors.lightOrange;
        break;
      case 2:
        return CColors.lightBlue;
        break;
      case 3:
        return CColors.fadeBlueAccent;
        break;
      case 4:
        return CColors.lightGrey;
        break;
      default:
        return CColors.lightOrange;
    }
  }

  Color textColor(Order order) {
    switch (order.status) {
      case 1:
        return CColors.darkOrange;
        break;
      case 2:
        return CColors.skyBlue;
        break;
      case 3:
        return CColors.darkGreen;
        break;
      case 4:
        return CColors.grey;
        break;
      default:
        return CColors.darkOrange;
    }
  }
  bool isAuthenticated = false;

  isAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userToken') != null) {
      setState(() {
        isAuthenticated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loadOrders
        ? Container(height: 200, child: Center(child: Loader()))
        : !isAuthenticated
        ? NotAuthPage()
        : _orders.length == 0
            ? NoData()
            : ListView.separated(
                itemCount: _orders.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 20, bottom: 30),
                separatorBuilder: (context, index) => SizedBox(height: 20),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: OrderCurrentListTile(
                      onTap: () => _showButtonPanel(_orders[index]),
                      billNumber: _orders[index].id,
                      billTotal: _orders[index].totalPrice,
                      billDate: _orders[index].createdAt,
                      backgroundColor: backGroundColor(_orders[index]),
                      leadingIconColor: textColor(_orders[index]),
                    ),
                  );
                },
              );
  }
}
