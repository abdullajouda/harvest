import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/customer/views/Favorite/favorites_tab.dart';
import 'package:harvest/customer/views/Orders/orders_tab.dart';
import 'package:harvest/customer/views/Support/support_tab.dart';
import 'package:harvest/customer/views/home/home.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/helpers/persistent_tab_controller_provider.dart';
import 'package:harvest/widgets/directions.dart';
import 'package:harvest/widgets/onExit.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootScreen extends StatefulWidget {
  final int index;

  const RootScreen({Key key, this.index = 0}) : super(key: key);
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  PersistentTabController _controller;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: widget.index);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PTVController>().setController(_controller);
    });

    super.initState();
  }

  List<Widget> _buildScreens() {
    return [
      Home(),
      OrdersTab(),
      FavoritesTab(),
      SupportTab(),
    ];
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: SvgPicture.asset(Constants.homeIcon),
          ),
          title: "home".trs(context),
          activeColor: CColors.lightGreen,
          activeColorAlternate: CColors.white,
          textStyle: TextStyle(fontSize: 14),
        ),
        PersistentBottomNavBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: SvgPicture.asset(Constants.orderIcon),
          ),
          title: "Orders".trs(context),
          activeColor: CColors.lightGreen,
          activeColorAlternate: CColors.white,
          textStyle: TextStyle(fontSize: 14),
        ),
        PersistentBottomNavBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: SvgPicture.asset(Constants.favoriteIcon),
          ),
          title: "Favorite".trs(context),
          activeColor: CColors.lightGreen,
          activeColorAlternate: CColors.white,
          textStyle: TextStyle(fontSize: 14),
        ),
        PersistentBottomNavBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: SvgPicture.asset(Constants.supportIcon),
          ),
          title: "Support".trs(context),
          activeColor: CColors.lightGreen,
          activeColorAlternate: CColors.white,
          textStyle: TextStyle(fontSize: 14),
        ),
      ];
    }
    return OnExit(
      child: Direction(
        child: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          // confineInSafeArea: false,
          bottomScreenMargin: 40,
          backgroundColor: Colors.white,
          // handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: false,
          // This needs to be true if you want to move up the screen when keyboard appears.
          stateManagement: false,
          hideNavigationBarWhenKeyboardShows: true,
          // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 400),
          ),
          navBarStyle: NavBarStyle.style7,
        ),
      ),
    );
  }
}
