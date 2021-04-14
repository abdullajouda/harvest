import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/Profile/user_profile.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/Wallet/wallet.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/about_us.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/notifications.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/privacy.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/terms.dart';
import 'package:harvest/customer/views/root_screen.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:harvest/main.dart';
import 'package:harvest/widgets/dialogs/logout_confirm.dart';
import 'package:provider/provider.dart';
import 'package:harvest/helpers/persistent_tab_controller_provider.dart';
import 'package:harvest/helpers/Localization/app_translations.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/find_us.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'directions.dart';

class HomePopUpMenuModel {
  final String iconPath;
  final String title;
  final VoidCallback onPressed;

  HomePopUpMenuModel({
    @required this.iconPath,
    @required this.title,
    this.onPressed,
  });
}

class HomePopUpMenu extends StatefulWidget {
  HomePopUpMenu({
    Key key,
  }) : super(key: key);

  @override
  _HomePopUpMenuState createState() => _HomePopUpMenuState();
}

class _HomePopUpMenuState extends State<HomePopUpMenu> {
  signOut() async {
    showCupertinoDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) => Center(child: ConfirmDialog()),
    );
  }

  bool isAuthenticated = false;

  isAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userToken') != null) {
      setState(() {
        isAuthenticated = true;
      });
    }
  }

  @override
  void initState() {
    isAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<HomePopUpMenuModel> _options = [
      HomePopUpMenuModel(
        iconPath: Constants.homeMenuIcon,
        title: 'Home',
        onPressed: () =>
            Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(
            // context: context,
            builder: (context) => RootScreen(),
          ),
        ),
      ),
      if (isAuthenticated)
        HomePopUpMenuModel(
          iconPath: Constants.profileMenuIcon,
          title: 'Profile',
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                // context: context,
                builder: (context) => UserProfile(),
              ),
            );
          },
        ),
      if (isAuthenticated)
        HomePopUpMenuModel(
          iconPath: 'assets/icons/credit-card.svg',
          title: 'wallet',
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (context) => Wallet(),
            ));
          },
        ),
      HomePopUpMenuModel(
        iconPath: 'assets/icons/info.svg',
        title: 'About Us',
        onPressed: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => AboutUs(),
          ),
        ),
      ),
      HomePopUpMenuModel(
        iconPath: Constants.mailMenuIcon,
        title: 'Find Us',
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (context) => FindUS(),
            ),
          );
        },
      ),
      if (isAuthenticated)
        HomePopUpMenuModel(
          iconPath: 'assets/icons/bell.svg',
          title: 'Notifications',
          onPressed: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (context) => Notifications(),
            ),
          ),
        ),
      HomePopUpMenuModel(
        iconPath: Constants.termsMenuIcon,
        title: 'Terms of use',
        onPressed: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => Terms(),
          ),
        ),
      ),
      HomePopUpMenuModel(
        iconPath: Constants.privacyMenuIcon,
        title: 'Privacy',
        onPressed: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => Privacy(),
          ),
        ),
      ),
      if (isAuthenticated)
        HomePopUpMenuModel(
          iconPath: Constants.logoutMenuIcon,
          title: 'Sign out',
          onPressed: () {
            signOut();
          },
        ),
      if (!isAuthenticated)
        HomePopUpMenuModel(
          iconPath: Constants.profileMenuIcon,
          title: 'SignIn',
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.of(context, rootNavigator: true)
                .pushReplacement(MaterialPageRoute(
              builder: (context) => MyApp(),
            ));
          },
        ),
    ];
    return Direction(
      child: PopupMenuButton<int>(
        icon: SvgPicture.asset(Constants.menuIcon, width: 15, height: 15),
        padding: EdgeInsets.zero,
        offset: Offset(-50, 10),
        onSelected: (index) {
          final _item = _options[index];
          if (_item.onPressed != null)
            _item.onPressed();
        },
        onCanceled: null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        itemBuilder: (context) => List.generate(
          _options.length,
          (index) {
            final _option = _options[index];
            return PopupMenuItem(
              height: 40,
              value: index,
              enabled: _option.onPressed != null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_option.iconPath != null)
                      Container(
                        height: 15,
                        width: 15,
                        child: Center(
                          child: SvgPicture.asset(_option.iconPath,
                              color: Color(0x0ff525768), width: 15, height: 15),
                        ),
                      ),
                    SizedBox(width: 6),
                    Text(
                      _option.title.trs(context),
                      style: TextStyle(
                        fontSize: 16,
                        color: CColors.headerText,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
