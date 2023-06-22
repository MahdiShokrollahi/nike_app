import 'package:nike_app/features/feature_prodcut/data/model/product.dart';

class OrderModel {
  final int id;
  final int payablePrice;
  final List<ProductModel> items;

  OrderModel.fromJson(Map<String, dynamic> jsonObject)
      : id = jsonObject['id'],
        payablePrice = jsonObject['payable'],
        items = (jsonObject['order_items'] as List)
            .map((item) => ProductModel.fromJson(item['product']))
            .toList();
}
