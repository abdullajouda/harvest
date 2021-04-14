import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harvest/customer/components/WaveAppBar/pinned_header.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WaveAppBarBody extends StatelessWidget {
  final ScrollController scrollController;
  final ScrollPhysics scrollPhysics;
  final bool pinned;
  final bool enablePullToRefresh;
  final Widget leading;
  final Offset bottomViewOffset;
  final Widget bottomView;
  final List<Widget> actions;
  final bool hideActions;
  final Gradient backgroundGradient;
  final Object heroTag;
  final Color shadowColor;
  final Brightness brightness;

  ///Use `child` for single widget
  final List<Widget> children;

  ///you should use `Children` for multiple widgets
  final Widget child;
  final EdgeInsetsGeometry contentPadding;
  final PinnedTopHeader topHeader;
  final RefreshController refreshController;
  final VoidCallback onRefresh;

  const WaveAppBarBody({
    Key key,
    this.scrollController,
    this.scrollPhysics,
    this.pinned = false,
    this.leading,
    this.bottomViewOffset = Offset.zero,
    this.bottomView,
    this.actions,
    this.hideActions = false,
    this.backgroundGradient,
    this.heroTag,
    this.shadowColor,
    this.brightness = Brightness.light,
    this.children = const <Widget>[],
    this.child,
    this.contentPadding = EdgeInsets.zero,
    this.topHeader,
    this.refreshController,
    this.onRefresh,
    this.enablePullToRefresh = false,
  })  : assert(child != null || children != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return SafeArea(
      top: false,
      child: CustomScrollView(
        controller: scrollController,
        physics: scrollPhysics,
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: _WaveAppBarPersistentHeaderDelegate(
              pinned: pinned,
              statusBarHeight: topPadding,
              brightness: brightness,
              bottomView: bottomView,
              actions: actions,
              backgroundGradient: backgroundGradient,
              heroTag: heroTag,
              leading: leading,
              hideActions: hideActions,
              shadowColor: shadowColor,
              bottomViewOffset: bottomViewOffset,
              disableElevation: topHeader != null,
            ),
          ),
          if (topHeader != null)
            SliverPersistentHeader(
              pinned: topHeader.pinned,
              delegate: _PersistentPinnedTopHeader(
                pinnedTopHeader: topHeader,
              ),
            ),
          SliverPadding(
            padding: contentPadding,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (child != null)
                    return enablePullToRefresh
                        ? SmartRefresher(
                            enablePullDown: enablePullToRefresh,
                            header: WaterDropHeader(),
                            controller: refreshController,
                            onRefresh: onRefresh,
                            child: child)
                        : child;
                  return enablePullToRefresh
                      ? SmartRefresher(
                          enablePullDown: enablePullToRefresh,
                          header: WaterDropHeader(),
                          controller: refreshController,
                          onRefresh: onRefresh,
                          child: children[index])
                      : children[index];
                },
                childCount: child != null ? 1 : children.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _WaveAppBarPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final bool pinned;
  final double statusBarHeight;
  final Widget leading;
  final Offset bottomViewOffset;
  final Widget bottomView;
  final List<Widget> actions;
  final bool hideActions;
  final Gradient backgroundGradient;
  final Object heroTag;
  final Color shadowColor;
  final Brightness brightness;
  final bool disableElevation;

  const _WaveAppBarPersistentHeaderDelegate({
    this.pinned = false,
    this.statusBarHeight = kWaveAppBarDelegateCollapsedHeight,
    this.leading,
    this.bottomViewOffset,
    this.bottomView,
    this.actions,
    this.hideActions,
    this.backgroundGradient,
    this.heroTag,
    this.shadowColor,
    this.brightness,
    this.disableElevation = false,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.of(context).size;
    final double offset = min(shrinkOffset, maxExtent - minExtent);
    final double visibleMainHeight = max(maxExtent - shrinkOffset, minExtent);
    final double progress = offset / (maxExtent - minExtent);
    double radius;
    bool dropShadow;
    if (!disableElevation) {
      radius = (1 - progress) * kWaveAppBarRadius;
      dropShadow = progress >= 0.8 && radius == 0.0;
    }
    Widget appBar = WaveAppBar(
      radius: (1 - progress) * kWaveAppBarRadius,
      elevation: disableElevation
          ? 0.0
          : (dropShadow ? (progress * kShadowElevation) : 0),
      bottomViewOffset:
          Offset(0, progress * (maxExtent - minExtent)) + bottomViewOffset,
      brightness: brightness,
      bottomView: bottomView,
      actions: actions,
      backgroundGradient: backgroundGradient,
      heroTag: heroTag,
      leading: leading,
      hideActions: hideActions,
      shadowColor: shadowColor,
    );
    if (pinned) {
      Widget replacement = Container(
        height: visibleMainHeight,
        width: size.width,
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
      );
      return Visibility(
        visible: progress < 0.8,
        child: appBar,
        replacement: replacement,
      );
    }
    return appBar;
  }

  @override
  double get maxExtent => kWaveAppBarDelegateMaxHeight;

  @override
  double get minExtent =>
      pinned ? statusBarHeight : kWaveAppBarDelegateMinHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class _PersistentPinnedTopHeader extends SliverPersistentHeaderDelegate {
  final PinnedTopHeader pinnedTopHeader;

  const _PersistentPinnedTopHeader({
    this.pinnedTopHeader,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    final double progress = maxExtent == minExtent
        ? shrinkOffset / maxExtent
        : shrinkOffset / (maxExtent - minExtent);
    final bool dropShadow = shrinkOffset >= 0.0;
    return Material(
      elevation: dropShadow ? (progress * kShadowElevation) : 0,
      color: theme.scaffoldBackgroundColor,
      child: Container(
        // margin: pinnedTopHeader.margin,
        child: pinnedTopHeader.child,
      ),
    );
  }

  @override
  double get maxExtent => pinnedTopHeader.maxHeight;

  @override
  double get minExtent =>
      pinnedTopHeader.minHeight ?? pinnedTopHeader.maxHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
