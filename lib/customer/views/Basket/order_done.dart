import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/orders.dart';
import 'package:harvest/customer/views/root_screen.dart';
import 'package:harvest/customer/widgets/custom_main_button.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/persistent_tab_controller_provider.dart';
import 'package:harvest/widgets/directions.dart';
import 'package:provider/provider.dart';

class OrderDone extends StatelessWidget {
  final Order order;

  const OrderDone({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    var parsedDate = DateTime.parse(order.deliveryDate);
    var dateNow = DateTime.now();
    var finalDate = parsedDate.difference(dateNow).inDays;
    final size = MediaQuery.of(context).size;
    cart.clearAll();
    return Direction(
      child: Scaffold(
        // backgroundColor: CColors.lightGreen,
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              Image.asset(
                Constants.registerBackgroundPNG,
                width: size.width,
                height: size.height,
                fit: BoxFit.cover,
              ),
              SafeArea(
                child: Column(
                  children: [
                    // Align(
                    //   alignment: AlignmentDirectional.centerStart,
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 18),
                    //     child: InkWell(
                    //       onTap: () => Navigator.pop(context),
                    //       child: Container(
                    //         margin: EdgeInsets.all(10),
                    //         constraints: BoxConstraints(
                    //           maxHeight: 25,
                    //           maxWidth: 25,
                    //         ),
                    //         decoration: BoxDecoration(
                    //           color: CColors.white,
                    //           borderRadius: BorderRadius.circular(5),
                    //         ),
                    //         child: Icon(
                    //           Icons.chevron_left,
                    //           color: CColors.headerText,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: _HeaderCheckMark(),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "thank_you".trs(context),
                            style: TextStyle(
                              color: CColors.lightGreen,
                              fontSize: 33,
                            ),
                          ),
                          Text(
                            "we_have_recived_your_order".trs(context),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CColors.normalText,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            "bill".trs(context) + "\t#${order.id}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CColors.headerText,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "$finalDate\t" + "days".trs(context),
                            style: TextStyle(
                              color: CColors.darkOrange,
                              fontSize: 35,
                            ),
                          ),
                          Text(
                            "to_arrival".trs(context),
                            style: TextStyle(
                              color: CColors.headerText,
                              fontSize: 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25)
                                .add(EdgeInsets.only(bottom: 30, top: 20)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context,rootNavigator: true)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) => RootScreen(),
                                      ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: CColors.lightGreen, width: 2),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: SvgPicture.asset(
                                          Constants.homeMenuIcon,
                                          color: CColors.lightGreen,
                                          width: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  flex: 3,
                                  child: MainButton(
                                    onTap: () {
                                      Navigator.of(context,rootNavigator: true)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) => RootScreen(index: 1,),
                                      ));
                                    },
                                    constraints: BoxConstraints(),
                                    titlePadding: EdgeInsets.all(12),
                                    title: "order_details".trs(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCheckMark extends StatelessWidget {
  const _HeaderCheckMark({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Image.asset(Constants.orderDone, width: size.width),
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: CColors.lightGreen, width: 4),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.check, color: CColors.lightGreen, size: 25),
            ),
          ),
        ),
      ],
    );
  }
}
