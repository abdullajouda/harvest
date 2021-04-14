import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/category.dart';
import 'package:harvest/customer/models/favorite.dart';
import 'package:harvest/customer/models/featured_product.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/customer/models/offers_slider.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/customer/views/Basket/basket.dart';
import 'package:harvest/customer/views/home/special_products_details.dart';
import 'package:harvest/customer/views/product_details.dart';
import 'package:harvest/customer/widgets/Fruit_item.dart';
import 'package:harvest/customer/widgets/slider_item.dart';
import 'package:harvest/customer/widgets/special_item.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:harvest/widgets/Loader.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/widgets/basket_button.dart';
import 'package:harvest/widgets/directions.dart';
import 'package:harvest/widgets/home_popUp_menu.dart';
import 'package:harvest/widgets/my-opacity.dart';
import 'package:harvest/widgets/my_animation.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Category _selectedIndex;
  final _controller = AutoScrollController(
    axis: Axis.horizontal,
  );
  int _current = 0;
  final CarouselController _carouselController = CarouselController();
  List<Offers> _offers = [];
  List<Category> _categories = [];

  // List<Products> _products = [];
  List<FeaturedProduct> _featuredProducts = [];
  bool loadOffers = true;
  bool loadProducts = true;
  bool loadFeatured = true;
  bool loadCategories = true;
  bool loadBasket = true;

  getOffers() async {
    setState(() {
      loadOffers = true;
      _offers = [];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await get(ApiHelper.api + 'getSliders', headers: {
      'Accept': 'application/json',
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });

    var response = json.decode(request.body);
    var items = response['items'];
    // Fluttertoast.showToast(msg: response['message']);
    items.forEach((element) {
      Offers slider = Offers.fromJson(element);
      _offers.add(slider);
    });
    setState(() {
      loadOffers = false;
    });
  }

  Future getCategories() async {
    setState(() {
      _categories = [];
    });
    var request = await get(ApiHelper.api + 'getCategories', headers: {
      'Accept': 'application/json',
      'Accept-Language': LangProvider().getLocaleCode(),
    });
    var response = json.decode(request.body);
    List values = response['items'];
    values.forEach((element) {
      Category category = Category.fromJson(element);
      _categories.add(category);
    });
    setState(() {
      _selectedIndex = _categories[0];
      loadCategories = false;
    });
  }

  getFeaturedProducts() async {
    setState(() {
      _featuredProducts = [];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var settings = await get(ApiHelper.api + 'getSetting', headers: {
      'Accept': 'application/json',
      'Accept-Language': LangProvider().getLocaleCode(),
    });
    var set = json.decode(settings.body)['items'];
    if (set['show_featured'] == 1) {
      var request = await get(ApiHelper.api + 'getFeaturedProducts', headers: {
        'Accept': 'application/json',
        'fcmToken': prefs.getString('fcm_token'),
        'Accept-Language': LangProvider().getLocaleCode(),
      });
      var response = json.decode(request.body);
      List values = response['items'];
      values.forEach((element) {
        FeaturedProduct products = FeaturedProduct.fromJson(element);
        _featuredProducts.add(products);
      });
    }
    setState(() {
      loadFeatured = false;
    });
  }

  getProductsByCategories(Category category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loadProducts = true;
    });
    FavoriteOperations op =
        Provider.of<FavoriteOperations>(context, listen: false);
    op.clearHome();
    var request = await get(
        ApiHelper.api + 'getProductsByCategoryId/${category.id}',
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

  getCart() async {
    var cart = Provider.of<Cart>(context, listen: false);
    // cart.clearFav();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await get(ApiHelper.api + 'getMyCart', headers: {
      'Accept': 'application/json',
      'fcmToken': prefs.getString('fcm_token'),
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });

    var response = json.decode(request.body);
    var items = response['items'];
    items.forEach((element) {
      CartItem item = CartItem.fromJson(element);
      cart.addItem(item);
    });
    setState(() {
      loadBasket = false;
    });
  }

  @override
  void initState() {
    getCart();
    getOffers();
    getFeaturedProducts();
    getCategories().then((value) => getProductsByCategories(_selectedIndex));
    super.initState();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await getCart();
    await getOffers();
    await getFeaturedProducts();
    await getCategories()
        .then((value) => getProductsByCategories(_selectedIndex));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    FavoriteOperations op = Provider.of<FavoriteOperations>(context);
    const Radius _chipBorderRadius = const Radius.circular(12.5);
    return Direction(
      child: Scaffold(
        appBar: WaveAppBar(
          height: 110,
          backgroundGradient: CColors.greenAppBarGradient(),
          bottomViewOffset: Offset(0, -15),
          bottomView: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              // width: 298.0,
              // height: 40.0,
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
                onFieldSubmitted: (value) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => SearchResults(
                          search: value,
                        ),
                      )).then((value) => getProductsByCategories(_selectedIndex));
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
          ),
          actions: [HomePopUpMenu()],
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context,rootNavigator: true)
                    .push(
                    MaterialPageRoute(
                    // context: context,
                    builder: (context) => Basket(),
                  ),
                )
                    .then((value) {
                  getProductsByCategories(_selectedIndex);
                  getFeaturedProducts();
                });
              },
              child: BasketButton()),
        ),
        body: SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(
            waterDropColor: CColors.darkGreen,
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView(
            // shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                child: Row(
                  children: [
                    Text(
                      'Offers'.trs(context),
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color(0xff3c4959),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Stack(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        loadOffers
                            ? Center(child: Loader())
                            : MyOpacity(
                                load: loadOffers,
                                child: CarouselSlider.builder(
                                  itemCount: _offers.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return HomeSlider(
                                      offers: _offers[index],
                                    );
                                  },
                                  options: CarouselOptions(
                                      viewportFraction: 1.0,
                                      enlargeCenterPage: false,
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 800),
                                      height: 135,
                                      enlargeStrategy:
                                          CenterPageEnlargeStrategy.height,
                                      enableInfiniteScroll:
                                          _offers.length == 1 ? false : true,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
                                        });
                                      }),
                                  carouselController: _carouselController,
                                ),
                              ),
                      ],
                    ),
                    Positioned(
                      bottom: 15,
                      right: LangProvider().getLocaleCode() == 'ar' ? null : 15,
                      left: LangProvider().getLocaleCode() == 'ar' ? 15 : null,
                      child: Container(
                        height: 20,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _offers.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: _current == index
                                  ? Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 7,
                                        width: 7,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(9999.0, 9999.0)),
                                          color: CColors.darkOrange,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 7,
                                        width: 7,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(9999.0, 9999.0)),
                                          color: CColors.white,
                                        ),
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _featuredProducts.length == 0
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 10),
                          child: Text(
                            'Special For You'.trs(context),
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color(0xff3c4959),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          height: 170,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            itemCount: _featuredProducts.length,
                            shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => GestureDetector(
                                onTap: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ProductBundleDetails(
                                        fruit: _featuredProducts[index],
                                      ),
                                    )).then((value) => getCart()),
                                child: SpecialItem(
                                  fruit: _featuredProducts[index],
                                )),
                          ),
                        ),
                      ],
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: MyOpacity(
                  load: loadCategories,
                  child: Container(
                      height: 30,
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: _controller,
                        padding: EdgeInsetsDirectional.only(start: 23),
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final _category = _categories[index];
                          final bool _isSelected =
                              _isIndexSelected(_categories[index]);
                          return AutoScrollTag(
                            controller: _controller,
                            index: index,
                            key: ValueKey(index),
                            child: GestureDetector(
                              onTap: () {
                                setState(
                                    () => _selectedIndex = _categories[index]);
                                // helper.setCat(_selectedIndex);
                                getProductsByCategories(_selectedIndex);
                                _controller.scrollToIndex(index);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 5),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: _isSelected
                                      ? CColors.darkOrange
                                      : CColors.transparent,
                                  borderRadius: BorderRadiusDirectional.only(
                                    topStart: _chipBorderRadius,
                                    bottomStart: _chipBorderRadius,
                                    topEnd: _chipBorderRadius,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _category.name ?? '',
                                    style: TextStyle(
                                      color: _isSelected
                                          ? CColors.white
                                          : CColors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                ),
              ),
              loadProducts
                  ? Center(
                      child: Container(
                          height: 200, width: 200, child: LoadingPhone()))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1,
                          crossAxisCount: 2,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18),
                      itemCount: op.homeItems.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 40),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => GestureDetector(
                        // onTap: () => Navigator.of(context, rootNavigator: true)
                        //     .push(
                        //       CupertinoPageRoute(
                        //         builder: (context) => ProductDetails(
                        //           fruit: op.homeItems.values.toList()[index],
                        //         ),
                        //       ),
                        //     )
                        //     .then((value) =>
                        //         getProductsByCategories(_selectedIndex)),
                        child: FruitItem(
                          fruit: op.homeItems.values.toList()[index],
                        ),
                      ),
                    ),
              // SizedBox(
              //   height: 50,
              // )
            ],
          ),
        ),
      ),
    );
  }

  bool _isIndexSelected(Category index) => _selectedIndex == index;
}
