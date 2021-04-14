import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/delivery_time_avaiable.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/directions.dart';
import 'package:http/http.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:provider/provider.dart';

import '../Loader.dart';

class AvailableDatesSheet extends StatefulWidget {
  @override
  _AvailableDatesSheetState createState() => _AvailableDatesSheetState();
}

class _AvailableDatesSheetState extends State<AvailableDatesSheet> {
  CarouselController _carouselController;
  List<AvailableDates> availableDates = [];
  bool loadDates = false;
  AvailableDates _selected;
  Times _selectedTime;

  getAvailableDates() async {
    setState(() {
      loadDates = true;
    });
    var request = await get(ApiHelper.api + 'getAvailableDates');
    var response = json.decode(request.body);
    List dates = response['items'];
    dates.forEach((element) {
      AvailableDates date = AvailableDates.fromJson(element);
      availableDates.add(date);
    });

    setState(() {
      _selected = availableDates[0];
      loadDates = false;
    });
  }

  @override
  void initState() {
    _carouselController = CarouselController();
    getAvailableDates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var cart = Provider.of<Cart>(context);
    return Direction(
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
            color: CColors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Card(
                elevation: 0.0,
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99)),
                child: SizedBox(width: size.width * 0.35, height: 6),
              ),
            ),
            Text(
              'Select an available Date/Time'.trs(context),
              style: TextStyle(
                fontSize: 18,
                color: const Color(0xff3c4959),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            loadDates
                ? Loader()
                : Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.navigate_before,
                            color: Color(0x0ffE3E7EB),
                          ),
                          onPressed: () {
                            _carouselController.previousPage();
                          },
                        ),
                        Container(
                          width: 120,
                          child: CarouselSlider.builder(
                              carouselController: _carouselController,
                              options: CarouselOptions(
                                height: 20,
                                enlargeCenterPage: true,
                                viewportFraction: 0.9,
                                aspectRatio: 2.0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _selected = availableDates[index];
                                  });
                                },
                              ),
                              itemCount: availableDates.length,
                              itemBuilder: (context, index, realIndex) {
                                return Text(
                                  '${availableDates[index].date}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xff3c984f),
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.navigate_next,
                            color: Color(0x0ffE3E7EB),
                          ),
                          onPressed: () {
                            _carouselController.nextPage();
                          },
                        ),
                      ],
                    ),
                  ),
            _selected != null
                ? Container(
                    height: 100,
                    child: ListView.builder(
                      itemCount: _selected.times.length,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTime = _selected.times[index];
                            });
                          },
                          child: Container(
                            height: 100,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0),
                              color: _isTimeSelected(_selected.times[index])
                                  ? CColors.darkOrange
                                  : Color(0xffffffff),
                              border: Border.all(
                                  width: 1.0, color: const Color(0x4df88518)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '${_selected.times[index].from}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _isTimeSelected(
                                                _selected.times[index])
                                            ? CColors.white
                                            : Color(0xff888a8d),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    // Text(
                                    //   'PM',
                                    //   style: TextStyle(
                                    //     fontSize: 14,
                                    //     color: _isTimeSelected(
                                    //             _selected.times[index])
                                    //         ? CColors.white
                                    //         : Color(0xff888a8d),
                                    //   ),
                                    //   textAlign: TextAlign.center,
                                    // )
                                  ],
                                ),
                                SvgPicture.asset(
                                  'assets/icons/seperator.svg',
                                  color: _isTimeSelected(_selected.times[index])
                                      ? CColors.white
                                      : Color(0xff888a8d),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${_selected.times[index].to}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _isTimeSelected(
                                                _selected.times[index])
                                            ? CColors.white
                                            : Color(0xff888a8d),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    // Text(
                                    //   'PM',
                                    //   style: TextStyle(
                                    //     fontSize: 14,
                                    //     color: _isTimeSelected(
                                    //             _selected.times[index])
                                    //         ? CColors.white
                                    //         : Color(0xff888a8d),
                                    //   ),
                                    //   textAlign: TextAlign.center,
                                    // )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: FlatButton(
                onPressed: () {
                  if (_selected != null && _selectedTime != null) {
                    cart.setDate(_selected);
                    cart.setTime(_selectedTime);
                  }
                  Navigator.of(context).pop({
                    'deliveryDate': _selected,
                    'deliveryTime': _selectedTime,
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: CColors.lightGreen,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "done".trs(context),
                    style: TextStyle(
                      color: CColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
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

  bool _isDateSelected(AvailableDates index) => _selected == index;

  bool _isTimeSelected(Times index) => _selectedTime == index;
}
