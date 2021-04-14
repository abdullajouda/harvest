import 'package:flutter/material.dart';
import 'package:harvest/customer/models/featured_product.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/helpers/color_converter.dart';
import 'package:harvest/helpers/Localization/localization.dart';

class SpecialItem extends StatelessWidget {
  final FeaturedProduct fruit;

  const SpecialItem({Key key, this.fruit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        height: 150,
        width: 115,
        child: Stack(
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            Positioned(
              left: 0,
              child: Container(
                height: 168,
                width: 105,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  color: HexColor.fromHex(fruit.specialFoodBg != ''
                      ? fruit.specialFoodBg
                      : '#5ECC74'),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x17000000),
                      offset: Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -16,
              bottom: -5,
              child: Container(
                decoration: BoxDecoration(
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: const Color(0x1a000000),
                    //     offset: Offset(0, 4),
                    //     blurRadius: 10,
                    //   ),
                    // ],
                    ),
                child: Image.network(
                  fruit.image,
                  fit: BoxFit.fitWidth,
                  width: 130.0,
                  height: 130.0,
                ),
              ),
            ),
            Positioned(
              left: LangProvider().getLocaleCode() == 'ar' ? null : 8,
              right: LangProvider().getLocaleCode() == 'ar' ? 15 : null,
              top: 15,
              child: Container(
                width: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fruit.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xffffffff),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '${fruit.discount > 0 && fruit.priceOffer > 0 ? fruit.price - (fruit.price * fruit.discount / 100) : fruit.price % 1 == 0 ? fruit.price.toStringAsFixed(0) : fruit.price}  ${'Q.R'.trs(context)}/${fruit.typeName}',
                      style: TextStyle(
                        fontSize: 10,
                        color: const Color(0xffffffff),
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
