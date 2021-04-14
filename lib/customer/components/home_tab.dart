import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/widgets/category_selector.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: WaveAppBarBody(
        bottomViewOffset: Offset(0, -10),
        topHeader: PinnedTopHeader(
          maxHeight: 45,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CategorySelector(),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            // Navigator.of(context, rootNavigator: true).push(
            //   platformPageRoute(
            //     context: context,
            //     builder: (context) => Basket(),
            //   ),
            // );
          },
          icon: SvgPicture.asset(
            Constants.basketIcon,
            fit: BoxFit.fitWidth,
            width: 20,
            height: 20,
          ),
        ),
        bottomView: Card(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.13),
          elevation: 10,
          shadowColor: Colors.black26,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.teal,
              borderRadius: BorderRadius.circular(999),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text.rich(
              TextSpan(
                text: "Save Up to 50%" + "\t\t",
                style: TextStyle(
                  color: CColors.lightOrange,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: "April Offers",
                    style: TextStyle(
                      color: CColors.normalText,
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        children: [
      //     Text(
      //       '12 Product on sale',
      //       style: TextStyle(
      //         fontFamily: 'SF Pro Rounded',
      //         fontSize: 20,
      //         color: const Color(0xff3c4959),
      //         fontWeight: FontWeight.w600,
      //       ),
      //       textAlign: TextAlign.left,
      //     ),
      // Container(
      //   height: 160,
      //   width: 160,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(20.0),
      //     color: const Color(0xffffffff),
      //     boxShadow: [
      //       BoxShadow(
      //         color: const Color(0x17000000),
      //         offset: Offset(0, 10),
      //         blurRadius: 21,
      //       ),
      //     ],
      //   ),
      // )
        ],
      ),
    );
  }
}

