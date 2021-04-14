import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harvest/customer/models/category.dart';
import 'package:harvest/customer/models/favorite.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CategorySelector extends StatefulWidget {
  final List<Category> categories;

  const CategorySelector({Key key, this.categories}) : super(key: key);
  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  Category _selectedIndex ;
  bool loadProducts = false;
  final _controller = AutoScrollController(
    axis: Axis.horizontal,
  );

  @override
  void initState() {
    _selectedIndex = widget.categories[0];
    // getProductsByCategories(_selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ApiHelper helper = Provider.of<ApiHelper>(context);
    const Radius _chipBorderRadius = const Radius.circular(12.5);
    return ListView.builder(
      shrinkWrap: true,
      controller: _controller,
      padding: EdgeInsetsDirectional.only(start: 23),
      scrollDirection: Axis.horizontal,
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        final _category = widget.categories[index];
        final bool _isSelected = _isIndexSelected(widget.categories[index]);
        return AutoScrollTag(
          controller: _controller,
          index: index,
          key: ValueKey(index),
          child: GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = widget.categories[index]);
              // helper.setCat(_selectedIndex);
              // getProductsByCategories(_selectedIndex);
              _controller.scrollToIndex(index);
            },
            child: Container(
              margin: EdgeInsets.only(right: 5),
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: _isSelected ? CColors.darkOrange : CColors.transparent,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: _chipBorderRadius,
                  bottomStart: _chipBorderRadius,
                  topEnd: _chipBorderRadius,
                ),
              ),
              child: Center(
                child: Text(
                  _category.name??'',
                  style: TextStyle(
                    color: _isSelected ? CColors.white : CColors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isIndexSelected(Category index) => _selectedIndex == index;
}