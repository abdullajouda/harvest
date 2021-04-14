class ErrorModel {
  int id;
  int remain;

  ErrorModel({this.id, this.remain});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    remain = json['remain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['remain'] = this.remain;
    return data;
  }
}