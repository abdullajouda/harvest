import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harvest/customer/models/offers_slider.dart';
import 'package:harvest/customer/views/home/offers_page.dart';
import 'package:harvest/helpers/Localization/localization.dart';
class HomeSlider extends StatelessWidget {
  final Offers offers;

  const HomeSlider({Key key, this.offers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: offers.category != null
          ? () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => OffersPage(
                    offers: offers,
                    color: offers.backgroundColor,
                  ),
                ),
              );
            }
          : null,
      child: Container(
        height: 132.0,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(offers.image), fit: BoxFit.fitWidth),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: const Color(0x17000000),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: LangProvider().getLocaleCode() == 'ar'?null: 21,
              right: LangProvider().getLocaleCode() == 'ar'?21: null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text(
                  //   offers.title ?? '',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: const Color(0xffffffff),
                  //     letterSpacing: 0.266,
                  //     fontWeight: FontWeight.w300,
                  //   ),
                  //   textAlign: TextAlign.left,
                  // ),
                  // Text(
                  //   'Save Up to 50%',
                  //   style: TextStyle(
                  //     fontFamily: 'SF Pro Rounded',
                  //     fontSize: 18,
                  //     color: const Color(0xffffffff),
                  //     letterSpacing: 0.34199999999999997,
                  //     fontWeight: FontWeight.w600,
                  //     ),
                  //   textAlign: TextAlign.left,
                  // ),
                  offers.category != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            height: 24,
                            width: 77,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: const Color(0xffffffff),
                            ),
                            child: Center(
                              child: Text(
                                'See More'.trs(context),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: const Color(0xfff88518),
                                  letterSpacing: 0.19,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
