import 'package:harvest/customer/models/products.dart';

class OrderProduct {
  int id;
  int orderId;
  int productId;
  double quantity;
  double price;
  Products product;

  OrderProduct(
      {this.id,
      this.orderId,
      this.productId,
      this.quantity,
      this.price,
      this.product});

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    quantity = json['quantity'] != null ? double.parse(json['quantity'].toString()) : null;
    price =
        json['price'] != null ? double.parse(json['price'].toString()) : null;
    product =
        json['product'] != null ? new Products.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}
