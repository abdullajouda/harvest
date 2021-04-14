import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/delivery-data.dart';
import 'package:harvest/customer/models/error.dart';
import 'package:harvest/customer/models/orders.dart';
import 'package:harvest/customer/views/Basket/pages_controlles.dart';
import 'package:harvest/customer/views/Basket/stepper.dart';
import 'package:harvest/customer/views/Basket/steps/basket_step.dart';
import 'package:harvest/customer/views/Basket/steps/billing_step.dart';
import 'package:harvest/customer/views/Basket/steps/delivery_time_step.dart';
import 'package:harvest/customer/views/Basket/steps/places_step.dart';
import 'package:harvest/customer/views/webview.dart';
import 'package:harvest/customer/widgets/custom_icon_button.dart';
import 'package:harvest/helpers/Localization/lang_provider.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/backButton.dart';
import 'package:harvest/widgets/dialogs/choose%20time.dart';
import 'package:harvest/widgets/dialogs/minimun_charge.dart';
import 'package:harvest/widgets/dialogs/select_payment.dart';
import 'package:harvest/widgets/dialogs/no_delivery_location.dart';
import 'package:harvest/widgets/dialogs/signup_dialog.dart';
import 'package:harvest/widgets/dialogs/use_wallet.dart';
import 'package:harvest/widgets/sheets/order_description.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'order_done.dart';

enum _BasketSteps { Basket, Place, Delivery_Time, Billing }

class Basket extends StatefulWidget {
  @override
  _BasketState createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  ValueNotifier<int> _pagesNotifiew = ValueNotifier<int>(0);
  int _step = 0;
  bool isAuth = false;
  bool load = false;



  Map<Widget, bool> _stepsAdv;

  checkOut() async {
    var cart = Provider.of<Cart>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await post(ApiHelper.api + 'checkOut', body: {
      'delivery_address': cart.deliveryAddresses.id.toString(),
      'delivery_date_id': cart.availableDates.id.toString(),
      'delivery_time_id': cart.time.id.toString(),
      'delivery_date': '${cart.availableDates.dateWithoutFormat}',
      'payment_method': '${cart.paymentType}',
      'use_wallet': '${cart.useWallet}',
      'note': '${cart.additionalNote != null ? cart.additionalNote : ''}',
      'promoCode_name': '${cart.promo != null ? cart.promo : ''}'
    }, headers: {
      'Accept': 'application/json',
      'fcmToken': prefs.getString('fcm_token'),
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    print(response);
    Fluttertoast.showToast(msg: response['message']);
    if (response['code'] == 200) {
      Order order = Order.fromJson(response['order']);
      if(response['payment_link'] != ''){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewExample(
                order: order,
                url: response['payment_link'],
              ),
            ));
      }else{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDone(
                order: order,
              ),
            ));
      }

    } else if (response['code'] == 204) {
      showCupertinoDialog(
        context: context,
        builder: (context) => MinimumChargeDialog(
          subTitle: response['message'],
        ),
      );
    } else if (response['code'] == 205) {
      var list = response['items'];
      // cart.addError(index);
      list.forEach((element) {
        ErrorModel model = ErrorModel.fromJson(element);
        cart.addError(model);
        // cart.addError(int.parse(element.toString()));
      });

      setState(() {
        _step = 0;
      });
      return _jumpTo(_step);
    }

  }

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userToken') != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  checkCartItems(int path)async{
    setState(() {
      load = true;
    });
    var cart = Provider.of<Cart>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await post(ApiHelper.api + 'checkCart', body: {
      'delivery_address': cart.deliveryAddresses.id.toString(),
    }, headers: {
      'Accept': 'application/json',
      'fcmToken': prefs.getString('fcm_token'),
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    print(response);
    if (response['code'] == 200) {
      if(path == 1){
        Navigator.pop(context);
      }
      _step++;
      return _jumpTo();
    }
    else if (response['code'] == 204) {
      showCupertinoDialog(
        context: context,
        builder: (context) => MinimumChargeDialog(
          subTitle: response['message'],
        ),
      );
    }
    else if (response['code'] == 205) {
      var list = response['items'];
      // cart.addError(index);
      list.forEach((element) {
        ErrorModel model = ErrorModel.fromJson(element);
        cart.addError(model);
        // cart.addError(int.parse(element.toString()));
      });
      setState(() {
        _step = 0;
      });
      return _jumpTo(_step);
    }
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    var cart = Provider.of<Cart>(context, listen: false);
    checkToken();
    _stepsAdv = {
      BasketStep(
        onErrorFound: () {
          if (isAuth) {
            setState(() {
              _step = 0;
            });
            return _jumpTo(_step);
          } else {
            showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => SignUpDialog(),
            );
          }
        },
        onContinuePressed: () {
          if (isAuth) {
            setState(() {
              _step = 1;
            });
            showModalBottomSheet(
                    context: context,
                    backgroundColor: CColors.transparent,
                    isDismissible: false,
                    enableDrag: false,
                    builder: (context) => OrderDescription(
                      onTap: () {
                        checkCartItems(1);
                      },
                    ),
                    isScrollControlled: true);
            return _jumpTo();
          } else {
            showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => SignUpDialog(),
            );
          }
        },
      ): true,
      PlaceStep(
      ): false,
      DeliveryTimeStep(): false,
      BillingStep(): false,
    };
    super.initState();
  }

  @override
  void dispose() {
    var cart = Provider.of<Cart>(context, listen: false);
    cart.clearAll();
    _pagesNotifiew?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    return Directionality(
      textDirection: LangProvider().getLocaleCode()=='ar'?TextDirection.rtl:TextDirection.ltr,
      child: Scaffold(
        appBar: WaveAppBar(
            // hideActions: true,
            backgroundGradient: CColors.greenAppBarGradient(),
            actions: [Container()],
            leading: MyBackButton()),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: ValueListenableBuilder(
                  valueListenable: _pagesNotifiew,
                  builder: (context, value, child) => child,
                  child: Container(
                    // color: Colors.teal,
                    child: BasketStepper(
                      currentStep: _step,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: _pagesNotifiew.value.round(),
                  children: _stepsAdv.keys.map((step) {
                    final _isVisible = _stepsAdv[step];
                    return Visibility(
                      visible: _isVisible,
                      child: step,
                    );
                  }).toList(),
                ),
              ),
              ValueListenableBuilder<int>(
                valueListenable: _pagesNotifiew,
                builder: (context, index, child) {
                  final _BasketSteps _currentStep = _getCurrentStep(index);
                  if (_currentStep == _BasketSteps.Basket) return SizedBox();
                  return BasketPagesControlles(
                    onContinuePressed: () {
                      setState(() {
                        if (index != 3) {
                          if (index != 2) {
                            if (index != 1) {
                              _step++;
                              return _jumpTo();
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: CColors.transparent,
                                  isDismissible: false,
                                  enableDrag: false,
                                  builder: (context) => OrderDescription(
                                    onTap: () {
                                      checkCartItems(1);
                                    },
                                  ),
                                  isScrollControlled: true);
                            }
                          }
                          else {
                            if (cart.availableDates == null ||
                                cart.time == null) {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => ChooseTime(),
                              );
                            } else {
                              checkCartItems(0);
                            }
                          }
                        } else {
                          if (cart.paymentType == null) {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) => SelectPaymentDialog(),
                            );
                          } else {
                            if(double.parse(cart.walletBalance.toString()) > 0){
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => UseWallet(),
                              ).then((value) => checkOut());
                            }else{
                              checkOut();
                            }
                          }
                        }
                      });
                    },
                    onPrevPressed: () {
                      setState(() {
                        if (index != 0) {
                          _step--;
                        }
                      });
                      return _jumpTo(index - 1);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _BasketSteps _getCurrentStep(int index) => _BasketSteps.values[index];

  ///`toIndex` has a default value which is the current index value + 1
  void _jumpTo([int toIndex]) {
    final _value = _pagesNotifiew.value;
    if (toIndex == null) toIndex = _value + 1;
    if (toIndex > _stepsAdv.length - 1) return;
    if (_value < toIndex) {
      final _nextKey = _stepsAdv.entries.toList()[toIndex].key;
      _stepsAdv[_nextKey] = true;
    }
    return setState(() => _pagesNotifiew.value = toIndex);
  }

// Future<void> _clearStepsVisiablity() {
//   bool _skippedFirst = false;
//   _stepsAdv.forEach((key, _) {
//     if (_skippedFirst) {
//       _stepsAdv[key] = false;
//     } else {
//       _skippedFirst = true;
//     }
//   });
//   return Future<void>.value();
// }
}
