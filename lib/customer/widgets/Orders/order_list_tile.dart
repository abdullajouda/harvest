import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';

class OrderListTile extends StatelessWidget {
  final VoidCallback onTap;
  final int billNumber;
  final String billDate;
  final double billTotal;
  final Color backgroundColor;
  final Color leadingIconColor;

  const OrderListTile({
    Key key,
    this.onTap,
    this.billNumber = 0,
    this.billDate = "26 Jan. 2021",
    this.billTotal = 0.0,
    this.backgroundColor,
    this.leadingIconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _sections = [
      _OrderListTileSection(
        title: "bill_no".trs(context),
        subTitle: billNumber.toString(),
      ),
      _OrderListTileSection(
        title: "bill_date".trs(context),
        subTitle: billDate.substring(0, 10),
      ),
      _OrderListTileSection(
        title: "bill_total".trs(context),
        subTitle: "${'Q.R'.trs(context)} " + '${billTotal ?? 0.0}',
      ),
    ];
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: size.width,
        height: 57,
        decoration: BoxDecoration(
          color: backgroundColor ?? Color(0xffF9F9F9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: _buildListTileShadows(),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                height: 37,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color(0xfff9f9f9),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  SvgPicture.asset(Constants.orderIcon,
                      color: leadingIconColor ?? CColors.headerText),
                  SizedBox(width: 20),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _sections.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return _sections[index];
                      },
                      separatorBuilder: (context, index) => _VerticalDivider(),
                    ),
                  ),
                  Icon(FontAwesomeIcons.ellipsisV,
                      color: Colors.grey[300], size: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BoxShadow> _buildListTileShadows() {
    return <BoxShadow>[
      BoxShadow(
        offset: Offset(0.0, 5.0),
        blurRadius: 10.0,
        spreadRadius: 1.0,
        color: Color(0x05000000),
      ),
      BoxShadow(
        offset: Offset(0.0, 3.0),
        blurRadius: 10.0,
        spreadRadius: 1.0,
        color: Color(0x10000000),
      ),
    ];
  }
}

class _OrderListTileSection extends StatelessWidget {
  final String title;
  final String subTitle;
  final TextStyle titleTextStyle;
  final TextStyle subTitleTextStyle;

  const _OrderListTileSection({
    Key key,
    this.title,
    this.subTitle,
    this.titleTextStyle = const TextStyle(),
    this.subTitleTextStyle = const TextStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: CColors.headerText,
            fontWeight: FontWeight.w600,
          ).merge(titleTextStyle),
        ),
        Text(
          subTitle,
          style: TextStyle(
            fontSize: 11,
            color: CColors.headerText,
            fontWeight: FontWeight.normal,
          ).merge(subTitleTextStyle),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      width: 1,
      color: Colors.grey[200],
    );
  }
}
