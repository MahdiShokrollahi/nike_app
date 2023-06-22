class AddToCartModel {
  final int productId;
  final int cartItemId;
  final int count;

  AddToCartModel(this.productId, this.cartItemId, this.count);

  AddToCartModel.fromJson(Map<String, dynamic> json)
      : productId = json['product_id'],
        cartItemId = json['id'],
        count = json['count'];
}
