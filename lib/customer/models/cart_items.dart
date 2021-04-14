import 'package:flutter/cupertino.dart';
import 'package:harvest/customer/models/products.dart';

import 'delivery-data.dart';
import 'delivery_time_avaiable.dart';
import 'error.dart';

class CartItem {
  int id;
  int userId;
  String fcmToken;
  double quantity;
  int productId;
  String createdAt;
  Products product;

  CartItem({this.id,
    this.userId,
    this.fcmToken,
    this.quantity,
    this.productId,
    this.createdAt,
    this.product});

  CartItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fcmToken = json['fcm_token'];
    quantity = double.parse(json['quantity'].toString());
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
    data['quantity'] = this.quantity;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class Cart with ChangeNotifier {
  Map<String, ErrorModel> _errors = {};
  int paymentType;
  int useWallet;
  double total;
  double totalPrice;
  String additionalNote;
  String walletBalance;
  String promo;
  bool isFree;
  DeliveryAddresses deliveryAddresses;
  AvailableDates availableDates;
  Times time;

  void setDate(AvailableDates date) {
    availableDates = date;
    notifyListeners();
  }

  void setIsFree(bool free) {
    isFree = free;
    notifyListeners();
  }

  void setTime(Times times) {
    time = times;
    notifyListeners();
  }

  void setAddress(DeliveryAddresses addresses) {
    deliveryAddresses = addresses;
    notifyListeners();
  }

  void setTotal(double tot) {
    total = tot;
    notifyListeners();
  }

  void setTotalPrice(double tot) {
    totalPrice = tot;
    notifyListeners();
  }

  void setAdditional(String note) {
    additionalNote = note;
    notifyListeners();
  }

  void setPromo(String code) {
    promo = code;
    notifyListeners();
  }

  void setWalletBalance(String bal) {
    walletBalance = bal;
    notifyListeners();
  }

  void setPaymentType(int type) {
    paymentType = type;
    notifyListeners();
  }

  void setUseWallet(int type) {
    useWallet = type;
    notifyListeners();
  }


  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get items {
    return {..._cartItems};
  }

  Map<String, ErrorModel> get errors {
    return _errors;
  }

  int get itemCount {
    return _cartItems.length;
  }

  void addItem(CartItem item) {
    if (_cartItems.containsKey(item.productId)) {
      _cartItems.update(item.productId.toString(), (existing) =>
          CartItem(
            createdAt: item.createdAt,
              quantity: item.quantity,
              productId: item.productId,
              product: item.product,
              id: item.id,
              fcmToken: item.fcmToken,
              userId: item.userId
          ));
          } else {
          _cartItems.putIfAbsent(item.productId.toString(), () => item);
          }
          notifyListeners();
    }

  void addError(ErrorModel error) {
    if (_errors.containsKey(error.id)) {
      _errors.update(error.id.toString(), (existing) => error);
    } else {
      _errors.putIfAbsent(error.id.toString(), () => error);
    }
    notifyListeners();
  }

  void removeCartItem(int id) {
    _cartItems.removeWhere((key, value) => key == id.toString());
    items.removeWhere((key, value) => key == id.toString());
    notifyListeners();
  }

  void clearFav() {
    _cartItems = {};
    notifyListeners();
  }

  void clearAll() {
    _cartItems = {};
    _errors = {};
    total = null;
    paymentType = null;
    totalPrice = null;
    additionalNote = null;
    promo = null;
    deliveryAddresses = null;
    availableDates = null;
    time = null;
    notifyListeners();
  }
}
