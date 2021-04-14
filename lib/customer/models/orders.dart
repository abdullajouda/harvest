import 'package:harvest/customer/models/user.dart';

import 'delivery-data.dart';

class Order {
  int id;
  int userId;
  String deliveryAddress;
  double deliveryCost;
  String codeName;
  double productsTotal;
  double totalPrice;
  int status;
  double payment;
  String note;
  int isPaid;
  String transId;
  int driverId;
  String deliveryDate;
  String createdAt;
  String statusName;
  int discount;
  User user;
  DeliveryDay deliveryDay;
  DeliveryTime deliveryTime;
  DeliveryAddresses address;

  Order(
      {this.id,
      this.userId,
      this.deliveryAddress,
      this.deliveryCost,
      this.codeName,
      this.productsTotal,
      this.totalPrice,
      this.status,
      this.payment,
      this.note,
      this.isPaid,
      this.transId,
      this.driverId,
      this.deliveryDate,
      this.createdAt,
      this.statusName,
      this.discount,
      this.user,
      this.deliveryDay,
      this.deliveryTime,
      this.address});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    deliveryAddress = json['delivery_address'];
    deliveryCost = json['delivery_cost'] != null
        ? double.parse(json["delivery_cost"].toString())
        : null;
    codeName = json['code_name'];
    productsTotal = json['products_total'] != null
        ? double.parse(json["products_total"].toString())
        : null;
    totalPrice = json['total_price'] != null
        ? double.parse(json["total_price"].toString())
        : null;
    status = json['status'];
    payment = json['payment'] != null
        ? double.parse(json['payment'].toString())
        : null;
    note = json['note'];
    isPaid = json['is_paid'];
    transId = json['trans_id'];
    driverId = json['driver_id'];
    deliveryDate = json['delivery_date'];
    createdAt = json['created_at'];
    statusName = json['status_name'];
    discount = json['discount'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    deliveryDay = json['delivery_day'] != null
        ? new DeliveryDay.fromJson(json['delivery_day'])
        : null;
    deliveryTime = json['delivery_time'] != null
        ? new DeliveryTime.fromJson(json['delivery_time'])
        : null;
    address = json['address'] != null
        ? new DeliveryAddresses.fromJson(json['address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['delivery_address'] = this.deliveryAddress;
    data['delivery_cost'] = this.deliveryCost;
    data['code_name'] = this.codeName;
    data['products_total'] = this.productsTotal;
    data['total_price'] = this.totalPrice;
    data['status'] = this.status;
    data['payment'] = this.payment;
    data['note'] = this.note;
    data['is_paid'] = this.isPaid;
    data['trans_id'] = this.transId;
    data['driver_id'] = this.driverId;
    data['delivery_date'] = this.deliveryDate;
    data['created_at'] = this.createdAt;
    data['status_name'] = this.statusName;
    data['discount'] = this.discount;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.deliveryDay != null) {
      data['delivery_day'] = this.deliveryDay.toJson();
    }
    if (this.deliveryTime != null) {
      data['delivery_time'] = this.deliveryTime.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    return data;
  }
}
