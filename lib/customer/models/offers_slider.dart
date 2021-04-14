import 'category.dart';
class Offers {
  int id;
  String image;
  int categoryId;
  String backgroundColor;
  String createdAt;
  String title;
  Category category;

  Offers(
      {this.id,
        this.image,
        this.categoryId,
        this.backgroundColor,
        this.createdAt,
        this.title,
        this.category});

  Offers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    categoryId = json['category_id'];
    backgroundColor = json['background_color'];
    createdAt = json['created_at'];
    title = json['title'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['category_id'] = this.categoryId;
    data['background_color'] = this.backgroundColor;
    data['created_at'] = this.createdAt;
    data['title'] = this.title;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    return data;
  }
}

