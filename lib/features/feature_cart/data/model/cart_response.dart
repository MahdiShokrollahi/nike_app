import 'package:nike_app/features/feature_cart/data/model/cart_item.dart';

class CartResponse {
  final List<CartItemModel> cartItems;
  int payablePrice;
  int totalPrice;
  int shippingCost;

  CartResponse.fromJson(Map<String, dynamic> jsonObject)
      : cartItems = CartItemModel.parseJsonArray(jsonObject['cart_items']),
        payablePrice = jsonObject['payable_price'],
        totalPrice = jsonObject['total_price'],
        shippingCost = jsonObject['shipping_cost'];
}
