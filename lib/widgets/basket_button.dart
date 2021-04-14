import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/views/Basket/basket.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:provider/provider.dart';

class BasketButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    return Container(
      width: 33,
      height: 25,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                bottom: 0,
                left: 0,
                child: SvgPicture.asset(Constants.basketIcon)),
            cart.items.length == 0
                ? Container()
                : Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.elliptical(9999.0, 9999.0)),
                        color: const Color(0xfff88518),
                      ),
                      child: Center(
                        child: Text(
                          cart.items.length.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
