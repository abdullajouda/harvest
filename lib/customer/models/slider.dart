class SliderModel {
  int id;
  String image;
  String link;
  String createdAt;
  String details;
  String title;

  SliderModel(
      {this.id,
        this.image,
        this.link,
        this.createdAt,
        this.details,
        this.title});

  SliderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    link = json['link'];
    createdAt = json['created_at'];
    details = json['details'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['link'] = this.link;
    data['created_at'] = this.createdAt;
    data['details'] = this.details;
    data['title'] = this.title;
    return data;
  }
}