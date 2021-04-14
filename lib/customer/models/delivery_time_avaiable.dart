class AvailableDates {
  int id;
  int dayId;
  String status;
  String createdAt;
  String dayName;
  String month;
  String dateWithoutFormat;
  String date;
  List<Times> times;

  AvailableDates(
      {this.id,
        this.dayId,
        this.status,
        this.createdAt,
        this.dayName,
        this.month,
        this.dateWithoutFormat,
        this.date,
        this.times});

  AvailableDates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dayId = json['day_id'];
    status = json['status'];
    createdAt = json['created_at'];
    dayName = json['day_name'];
    month = json['month'];
    dateWithoutFormat = json['date_without_format'];
    date = json['date'];
    if (json['times'] != null) {
      times = new List<Times>();
      json['times'].forEach((v) {
        times.add(new Times.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day_id'] = this.dayId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['day_name'] = this.dayName;
    data['month'] = this.month;
    data['date'] = this.date;
    if (this.times != null) {
      data['times'] = this.times.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Times {
  int id;
  int dateId;
  String from;
  String to;
  int maxOrders;
  String status;
  String createdAt;
  int currentOrders;

  Times(
      {this.id,
        this.dateId,
        this.from,
        this.to,
        this.maxOrders,
        this.status,
        this.createdAt,
        this.currentOrders});

  Times.fromJson(Map<String, dynamic> json) {
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