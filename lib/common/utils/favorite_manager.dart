import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_app/features/feature_prodcut/data/model/product.dart';

class FavoriteManger {
  final box = Hive.box<ProductModel>('ProductBox');
  ValueListenable<Box<ProductModel>> get listenable => box.listenable();

  void addFavorite(ProductModel productModel) {
    box.put(productModel.id, productModel);
  }

  void delete(ProductModel productModel) {
    box.delete(productModel.id);
  }

  List<ProductModel> get favorites => box.values.toList();

  bool isFavorite(ProductModel productModel) {
    return box.containsKey(productModel.id);
  }
}
