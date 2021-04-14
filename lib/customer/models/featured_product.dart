import 'package:harvest/customer/models/products.dart';

class FeaturedProduct {
  int id;
  int categoryId;
  int havePrice;
  int price;
  String image;
  int discount;
  String offerFrom;
  String offerTo;
  int type;
  int order;
  int isFeatured;
  String specialFoodBg;
  int qty;
  int minQty;
  double unitRate;
  int parentId;
  String createdAt;
  String availableOffer;
  double priceOffer;
  String typeName;
  int available;
  double inCart;
  String inFavorite;
  String name;
  String description;
  List<BasketItem> basketItem;

  FeaturedProduct(
      {this.id,
        this.categoryId,
        this.havePrice,
        this.price,
        this.image,
        this.discount,
        this.offerFrom,
        this.offerTo,
        this.type,
        this.order,
        this.isFeatured,
        this.specialFoodBg,
        this.qty,
        this.minQty,
        this.unitRate,
        this.parentId,
        this.createdAt,
        this.availableOffer,
        this.priceOffer,
        this.typeName,
        this.available,
        this.inCart,
        this.inFavorite,
        this.name,
        this.description,
        this.basketItem});

  FeaturedProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    havePrice = json['have_price'];
    price = json['price'];
    image = json['image'];
    discount = json['discount'];
    offerFrom = json['offer_from'];
    offerTo = json['offer_to'];
    type = json['type'];
    order = json['order'];
    isFeatured = json['is_featured'];
    specialFoodBg = json['special_food_bg'];
    qty = json['qty'];
    minQty = json['min_qty'];
    unitRate = double.parse(json['unit_rate'].toString());
    parentId = json['parent_id'];
    createdAt = json['created_at'];
    availableOffer = json['available_offer'];
    priceOffer = double.parse(json['price_offer'].toString());
    typeName = json['type_name'];
    available = json['available'];
    inCart = double.parse(json['in_cart'].toString());
    inFavorite = json['in_favorite'];
    name = json['name'];
    description = json['description'];
    if (json['basket_item'] != null) {
      basketItem = new List<BasketItem>();
      json['basket_item'].forEach((v) {
        basketItem.add(new BasketItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['have_price'] = this.havePrice;
    data['price'] = this.price;
    data['image'] = this.image;
    data['discount'] = this.discount;
    data['offer_from'] = this.offerFrom;
    data['offer_to'] = this.offerTo;
    data['type'] = this.type;
    data['order'] = this.order;
    data['is_featured'] = this.isFeatured;
    data['special_food_bg'] = this.specialFoodBg;
    data['qty'] = this.qty;
    data['min_qty'] = this.minQty;
    data['unit_rate'] = this.unitRate;
    data['parent_id'] = this.parentId;
    data['created_at'] = this.createdAt;
    data['available_offer'] = this.availableOffer;
    data['price_offer'] = this.priceOffer;
    data['type_name'] = this.typeName;
    data['available'] = this.available;
    data['in_cart'] = this.inCart;
    data['in_favorite'] = this.inFavorite;
    data['name'] = this.name;
    data['description'] = this.description;
    if (this.basketItem != null) {
      data['basket_item'] = this.basketItem.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BasketItem {
  int id;
  int itemId;
  int qty;
  Products item;

  BasketItem({this.id, this.itemId, this.qty, this.item});

  BasketItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    qty = json['qty'];
    item = json['item'] != null ? new Products.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['qty'] = this.qty;
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }
    return data;
  }
}
