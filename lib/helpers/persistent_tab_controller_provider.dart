import 'dart:developer';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

enum AppTabs { Home, Orders, Favorite, Support }

class PTVController {
  PersistentTabController _controller;

  void setController(PersistentTabController controller) {
    this._controller = controller;
    log("`PersistentTabViewController` as been set");
  }

  Future<void> jumbToTab(AppTabs tab) {
    assert(_controller != null);
    if (_indexToTab(_controller.index) == tab) return Future<void>.value();
    _controller.jumpToTab(_tabToIndex(tab));
    return Future<void>.value();
  }

  int _tabToIndex(AppTabs tab) {
    switch (tab) {
      case AppTabs.Home:
        return 0;
        break;
      case AppTabs.Orders:
        return 1;
        break;
      case AppTabs.Favorite:
        return 2;
        break;
      case AppTabs.Support:
        return 3;
        break;
      default:
        return -1;
        break;
    }
  }

  AppTabs _indexToTab(int index) {
    switch (index) {
      case 0:
        return AppTabs.Home;
        break;
      case 1:
        return AppTabs.Orders;
        break;
      case 2:
        return AppTabs.Favorite;
        break;
      case 3:
        return AppTabs.Support;
        break;
      default:
        return null;
        break;
    }
  }
}
