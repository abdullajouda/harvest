class Pages {
  int id;
  String createdAt;
  String title;
  String description;

  Pages({this.id, this.createdAt, this.title, this.description});

  Pages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}