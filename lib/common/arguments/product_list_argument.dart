import 'package:nike_app/features/feature_prodcut/data/model/product.dart';

class ProductListArgument {
  final int sort;
  final String searchTerm;

  ProductListArgument({required this.sort, this.searchTerm = ''});

  ProductListArgument.search(
      {this.sort = ProductSort.popular, required this.searchTerm});
}
