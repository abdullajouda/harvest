import 'city.dart';

class DeliveryAddresses {
  int id;
  int userId;
  String addressName;
  int cityId;
  String zone;
  String street;
  int buildingNumber;
  int unitNumber;
  String note;
  int isDefault;
  double lat;
  double lan;
  String address;
  City city;

  DeliveryAddresses(
      {this.id,
        this.userId,
        this.addressName,
        this.cityId,
        this.zone,
        this.street,
        this.buildingNumber,
        this.unitNumber,
        this.note,
        this.isDefault,
        this.lat,
        this.lan,
        this.address,
        this.city});

  DeliveryAddresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    addressName = json['address_name'];
    cityId = json['city_id'];
    zone = json['zone'];
    street = json['street'];
    buildingNumber = json['building_number'];
    unitNumber = json['unit_number'];
    note = json['note'];
    isDefault = json['is_default'];
    lat = double.parse(json['lat'].toString());
    lan = double.parse(json['lan'].toString());
    address = json['address'];
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['address_name'] = this.addressName;
    data['city_id'] = this.cityId;
    data['zone'] = this.zone;
    data['street'] = this.street;
    data['building_number'] = this.buildingNumber;
    data['unit_number'] = this.unitNumber;
    data['note'] = this.note;
    data['is_default'] = this.isDefault;
    data['lat'] = this.lat;
    data['lan'] = this.lan;
    data['address'] = this.address;
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    return data;
  }
}

class DeliveryDay {
  int id;
  int dayId;
  String status;
  String createdAt;
  String dayName;

  DeliveryDay({this.id, this.dayId, this.status, this.createdAt, this.dayName});

  DeliveryDay.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dayId = json['day_id'];
    status = json['status'];
    createdAt = json['created_at'];
    dayName = json['day_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day_id'] = this.dayId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['day_name'] = this.dayName;
    return data;
  }
}

class DeliveryTime {
  int id;
  int dateId;
  String from;
  String to;
  int maxOrders;
  String status;
  String createdAt;
  int currentOrders;

  DeliveryTime(
      {this.id,
        this.dateId,
        this.from,
        this.to,
        this.maxOrders,
        this.status,
        this.createdAt,
        this.currentOrders});

  DeliveryTime.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateId = json['date_id'];
    from = json['from'];
    to = json['to'];
    maxOrders = json['max_orders'];
    status = json['status'];
    createdAt = json['created_at'];
    currentOrders = json['current_orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date_id'] = this.dateId;
    data['from'] = this.from;
    data['to'] = this.to;
    data['max_orders'] = this.maxOrders;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['current_orders'] = this.currentOrders;
    return data;
  }
}