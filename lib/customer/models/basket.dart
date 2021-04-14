import 'package:harvest/customer/views/Basket/basket.dart';

import 'package:harvest/customer/views/Basket/basket.dart';

import 'package:harvest/customer/views/Basket/basket.dart';

import 'cart_items.dart';

class Basket {
  bool status;
  int code;
  String message;
  String total;
  List<CartItem> items;

  Basket({this.status, this.code, this.message, this.total, this.items});

  Basket.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    total = json['total'];
    if (json['items'] != null) {
      items = new List<CartItem>();
      json['items'].forEach((v) {
        items.add(new CartItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}