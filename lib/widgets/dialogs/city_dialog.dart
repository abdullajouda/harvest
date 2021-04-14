import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harvest/customer/models/city.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/directions.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:harvest/widgets/Loader.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:harvest/helpers/Localization/localization.dart';
class CityDropDown extends StatefulWidget {
  @override
  _CityDropDownState createState() => _CityDropDownState();
}

class _CityDropDownState extends State<CityDropDown> {
  bool load = true;
  TextEditingController _search;
  List<City> _cities = [];
  List<City> cities = [];

  search() {
    setState(() {
      _cities.clear();
    });
    // var op = Provider.of<CityOperations>(context, listen: false);
    cities.forEach((element) {
      if (element.name.toLowerCase().contains(_search.text)) {
        _cities.add(element);
        setState(() {});
      }
    });
    // _cities.add(value);
  }
  getCities() async {
    print('this is locale :'+LangProvider().getLocaleCode());
    var request = await get(ApiHelper.api + 'getCities', headers: {
      'Accept': 'application/json',
      'Accept-Language': LangProvider().getLocaleCode(),
    });
    var response = json.decode(request.body);
    var items = response['cities'];
    print('after');
    items.forEach((element) {
      City city = City.fromJson(element);
      cities.add(city);
    });
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    getCities();
    _search = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // var op = Provider.of<CityOperations>(context);
    // op.items.values.toList().forEach((element) {
    //   print(element.name);
    // });
    return Direction(
      child: Material(
        color: Colors.transparent,
        child: Directionality(
          textDirection: LangProvider().getLocaleCode()=='ar'?TextDirection.rtl:TextDirection.ltr,
          child: Container(
            height: 300,
            width: size.width * .7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: const Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                      controller: _search,
                      onChanged: (value) {
                        search();
                      },
                      style: TextStyle(
                        fontSize: 10,
                        color: const Color(0xff525768),
                      ),
                      cursorColor: CColors.darkOrange,
                      cursorWidth: 1,
                      decoration: locationFieldDecoration('city'.trs(context))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: load?Center(child: Loader()):Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border:
                      Border.all(width: 1.0, color: const Color(0xffe3e7eb)),
                    ),
                    child: _search.text != ''
                        ? ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        height: 0,
                      ),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _cities.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop({
                            'city': _cities[index],
                          });
                        },
                        child: Container(
                          height: 50,
                          width: size.width * .7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: Text(
                                  '${_cities[index].name}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: const Color(0xff525768),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop({
                                    'city': _cities[index],
                                  });
                                },
                                child: Text(
                                  'pick'.trs(context),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: CColors.darkGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        : ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        height: 0,
                      ),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: cities.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop({
                            'city': cities[index],
                          });
                        },
                        child: Container(
                          height: 50,
                          width: size.width * .7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: Text(
                                  '${cities[index].name}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: const Color(0xff525768),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop({
                                    'city': cities[index],
                                  });
                                },
                                child: Text(
                                  'pick'.trs(context),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: CColors.darkGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}