import 'package:flutter/material.dart';
import 'package:harvest/customer/models/products.dart';

class FavoriteModel {
  int id;
  int userId;
  Null fcmToken;
  int productId;
  String createdAt;
  Products product;

  FavoriteModel(
      {this.id,
      this.userId,
      this.fcmToken,
      this.productId,
      this.createdAt,
      this.product});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fcmToken = json['fcm_token'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    product =
        json['product'] != null ? new Products.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['fcm_token'] = this.fcmToken;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class FavoriteOperations with ChangeNotifier {
  Map<String, Products> _items = {};
  Map<String, Products> _homeProducts = {};

  Map<String, Products> get items {
    return {..._items};
  }

  Map<String, Products> get homeItems {
    return {..._homeProducts};
  }

  int get itemCount {
    return _items.length;
  }

  int get homeCount {
    return _homeProducts.length;
  }

  void addItem(Products model) {
    if (_items.containsKey(model.id)) {
      _items.update(model.id.toString(), (existing) => model);
    } else {
      _items.putIfAbsent(model.id.toString(), () => model);
    }
    notifyListeners();
  }

  void addHomeItem(Products model) {
    if (_homeProducts.containsKey(model.id)) {
      _homeProducts.update(model.id.toString(), (existing) => model);
    } else {
      _homeProducts.putIfAbsent(model.id.toString(), () => model);
    }
    notifyListeners();
  }

  getProduct(int id) {
    notifyListeners();
    return _homeProducts.containsKey(id);
  }

  void removeFav(Products model) {
    _items.removeWhere((key, value) => key == model.id.toString());
    notifyListeners();
  }
  void updateFavHome(Products model) {
    _homeProducts.update(model.id.toString(), (value) => model);
    notifyListeners();
  }

  void clearFav() {
    _items = {};
    notifyListeners();
  }

  void clearHome() {
    _homeProducts = {};
    notifyListeners();
  }
}
