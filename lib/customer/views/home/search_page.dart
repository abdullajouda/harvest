import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/customer/models/favorite.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/customer/views/Basket/basket.dart';
import 'package:harvest/customer/views/product_details.dart';
import 'package:harvest/customer/widgets/Fruit_item.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:harvest/widgets/backButton.dart';
import 'package:harvest/widgets/basket_button.dart';
import 'package:harvest/widgets/home_popUp_menu.dart';
import 'package:harvest/widgets/my_animation.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harvest/helpers/Localization/localization.dart';
class SearchResults extends StatefulWidget {
  final String search;

  const SearchResults({Key key, this.search}) : super(key: key);
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  bool loadProducts = false;

  searchProducts(String value)async{
      SharedPreferences prefs =await SharedPreferences.getInstance();
      setState(() {
        loadProducts = true;
      });
      FavoriteOperations op =
      Provider.of<FavoriteOperations>(context, listen: false);
      op.clearHome();
      var request = await get(
          ApiHelper.api + 'search?text=$value',
          headers: {
            'Accept': 'application/json',
            'fcmToken': prefs.getString('fcm_token'),
            'Accept-Language': LangProvider().getLocaleCode(),
            'Authorization': 'Bearer ${prefs.getString('userToken')}'
          });
      var response = json.decode(request.body);
      List values = response['items'];
      values.forEach((element) {
        Products products = Products.fromJson(element);
        op.addHomeItem(products);
      });
      setState(() {
        loadProducts = false;
      });

  }

  @override
  void initState() {
    searchProducts(widget.search);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FavoriteOperations op = Provider.of<FavoriteOperations>(context);
    return Scaffold(
      body: WaveAppBarBody(
        backgroundGradient: CColors.greenAppBarGradient(),
        bottomViewOffset: Offset(0, -10),
        bottomView: Container(
          width: 298.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: const Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                color: const Color(0x18000000),
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: TextFormField(
            initialValue: widget.search,
            onFieldSubmitted: (value) {
              searchProducts(value);
            },
            decoration: searchDecoration(
              'search_products'.trs(context),
              Container(
                height: 14,
                width: 14,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/search.svg',
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [HomePopUpMenu()],
        leading: MyBackButton(),
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              '${op.homeCount} ${'results_found'.trs(context)}',
              style: TextStyle(
                fontSize: 20,
                color: const Color(0xff3c4959),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          loadProducts
              ? Center(
              child:
              Container(height: 200, width: 200, child: LoadingPhone()))
              : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18),
            itemCount: op.homeItems.length,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => GestureDetector(
              // onTap: () =>
                  // Navigator.of(context, rootNavigator: true).push(
                  //   CupertinoPageRoute(
                  //     builder: (context) => ProductDetails(
                  //       fruit: op.homeItems.values.toList()[index],
                  //     ),
                  //   ),
                  // ),
              child: FruitItem(
                fruit: op.homeItems.values.toList()[index],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
