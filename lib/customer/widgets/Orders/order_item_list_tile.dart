import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/Localization/localization.dart';

//TODO: Change the image to be `image.Netwrok()`
class OrderItemListTile extends StatelessWidget {
  final String name;
  final TextStyle nameStyle;
  final double itemsNum;
  final String image;
  final String type;
  final double price;
  final double pricePerKilo;
  final VoidCallback onTap;

  const OrderItemListTile({
    Key key,
    @required this.name,
    this.nameStyle,
    @required this.itemsNum,
    @required this.image,
    @required this.price,
    @required this.pricePerKilo,
    this.onTap,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
            child: ListTile(
              leading: Image.network(
                image,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  name,
                  style: TextStyle(
                    color: CColors.lightGreen,
                    fontSize: 16,
                  ).merge(nameStyle),
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        child: Text(
                          "$pricePerKilo ${'Q.R'.trs(context)}/$type",
                          style: TextStyle(
                            color: CColors.lightGreen,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "${itemsNum % 1 == 0 ? itemsNum.toStringAsFixed(0) :itemsNum.toStringAsFixed(2)} ${'items'.trs(context)}",
                        style: TextStyle(
                          color: CColors.headerText,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        (price*(double.parse(itemsNum.toString()))).toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 16,
                          color: CColors.headerText,
                        ),
                      ),
                      Text("  ${'Q.R'.trs(context)} ",
                        style: TextStyle(
                          fontSize: 13,
                          color: CColors.darkOrange,
                        ),)
                    ],
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
