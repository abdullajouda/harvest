import 'package:flutter/material.dart';

class City {
  int id;
  double deliveryCost;
  double minOrder;
  int welcomeCharge;
  int regularCharge;
  String createdAt;
  String name;

  City(
      {this.id,
        this.deliveryCost,
        this.minOrder,
        this.welcomeCharge,
        this.regularCharge,
        this.createdAt,
        this.name});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deliveryCost = double.parse(json['deliveryCost'].toString());
    minOrder = double.parse(json['min_order'].toString());
    welcomeCharge = json['welcome_charge'];
    regularCharge = json['regular_charge'];
    createdAt = json['created_at'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deliveryCost'] = this.deliveryCost;
    data['min_order'] = this.minOrder;
    data['welcome_charge'] = this.welcomeCharge;
    data['regular_charge'] = this.regularCharge;
    data['created_at'] = this.createdAt;
    data['name'] = this.name;
    return data;
  }
}
class CityOperations with ChangeNotifier {
  Map<String, City> _items = {};

  Map<String, City> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }



  void addItem(City model) {
    if (_items.containsKey(model.id)) {
      _items.update(model.id.toString(), (existing) => model);
    } else {
      _items.putIfAbsent(model.id.toString(), () => model);
    }
    notifyListeners();
  }

  void removeFav(City model) {
    _items.removeWhere((key, value) => key == model.id.toString());
    notifyListeners();
  }

  void clearCity() {
    _items.clear();
    notifyListeners();
  }


}
