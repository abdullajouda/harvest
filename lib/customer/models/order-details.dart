import 'package:harvest/customer/models/orders.dart';

import 'order-product.dart';

class OrderDetails {
  Order myOrder;
  List<OrderProduct> orderProduct;

  OrderDetails({this.myOrder, this.orderProduct});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    myOrder =
    json['myOrder'] != null ? new Order.fromJson(json['myOrder']) : null;
    if (json['orderProduct'] != null) {
      orderProduct = new List<OrderProduct>();
      json['orderProduct'].forEach((v) {
        orderProduct.add(new OrderProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.myOrder != null) {
      data['myOrder'] = this.myOrder.toJson();
    }
    if (this.orderProduct != null) {
      data['orderProduct'] = this.orderProduct.map((v) => v.toJson()).toList();
    }
    return data;
  }
}