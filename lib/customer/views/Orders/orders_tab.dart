import 'package:flutter/material.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/customer/views/Basket/basket.dart';
import 'package:harvest/customer/views/Orders/current_orders.dart';
import 'package:harvest/customer/views/Orders/old_orders.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:harvest/widgets/basket_button.dart';
import 'package:harvest/widgets/directions.dart';
import 'package:harvest/widgets/home_popUp_menu.dart';


enum _OrdersTabs { Current, Old }

class OrdersTab extends StatefulWidget {
  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  _OrdersTabs _ordersTab = _OrdersTabs.Current;


  @override
  Widget build(BuildContext context) {
    final _orderTabsTitles = [
      "current_order",
      "old_order",
    ];
    return Direction(
      child: Scaffold(
        appBar: WaveAppBar(
          backgroundGradient: CColors.greenAppBarGradient(),
          actions: [HomePopUpMenu()],
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context,rootNavigator: true)
                    .push(
                  MaterialPageRoute(
                    // context: context,
                    builder: (context) => Basket(),
                  ),
                );
              },
              child: BasketButton()),
        ),
        body: Column(
          children: [
            _buildTopSelector(_orderTabsTitles, context),
            Expanded(
                  child: _ordersTab == _OrdersTabs.Current
                      ? CurrentOrders()
                      : OldOrders(),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSelector(
      List<String> _orderTabsTitles, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      child: Row(
        children: List.generate(
          _OrdersTabs.values.length,
          (index) {
            final bool _isSelected =
                index == _OrdersTabs.values.indexWhere((e) => e == _ordersTab);
            return GestureDetector(
              onTap: () {
                setState(() => _ordersTab = _OrdersTabs.values[index]);
              },
              child: Card(
                elevation: 0.0,
                color: _isSelected ? CColors.darkOrange : CColors.transparent,
                margin: const EdgeInsetsDirectional.only(end: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(13),
                    topEnd: Radius.circular(13),
                    bottomStart: Radius.circular(13),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    _orderTabsTitles[index].trs(context),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _isSelected ? CColors.white : Color(0xff888a8d),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
