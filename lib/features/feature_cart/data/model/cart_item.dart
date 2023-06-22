import 'package:nike_app/features/feature_prodcut/data/model/product.dart';

class CartItemModel {
  final ProductModel product;
  final int id;
  int count;
  bool deleteButtonLoading = false;
  bool changeCountLoading = false;

  CartItemModel.fromJson(Map<String, dynamic> json)
      : product = ProductModel.fromJson(json['product']),
        id = json['cart_item_id'],
        count = json['count'];

  static List<CartItemModel> parseJsonArray(List<dynamic> jsonArray) {
    List<CartItemModel> cartItems = [];
    jsonArray.forEach((element) {
      cartItems.add(CartItemModel.fromJson(element));
    });
    return cartItems;
  }
}
