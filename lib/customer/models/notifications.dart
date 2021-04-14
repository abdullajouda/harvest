import 'package:flutter/material.dart';

class NotificationM {
  int id;
  int userId;
  int orderId;
  String message;
  String status;
  String createdAt;
  Null imageUser;
  String nameUser;
  int totalOrder;

  NotificationM(
      {this.id,
      this.userId,
      this.orderId,
      this.message,
      this.status,
      this.createdAt,
      this.imageUser,
      this.nameUser,
      this.totalOrder});

  NotificationM.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    message = json['message'];
    status = json['status'];
    createdAt = json['created_at'];
    imageUser = json['image_user'];
    nameUser = json['name_user'];
    totalOrder = json['total_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_id'] = this.orderId;
    data['message'] = this.message;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['image_user'] = this.imageUser;
    data['name_user'] = this.nameUser;
    data['total_order'] = this.totalOrder;
    return data;
  }
}

class NotificationOperations with ChangeNotifier {
  Map<String, NotificationM> _items = {};

  Map<String, NotificationM> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(NotificationM model) {
    if (_items.containsKey(model.id)) {
      _items.update(model.id.toString(), (existing) => model);
    } else {
      _items.putIfAbsent(model.id.toString(), () => model);
    }
    notifyListeners();
  }

  void clearNotes() {
    _items = {};
    notifyListeners();
  }
}
