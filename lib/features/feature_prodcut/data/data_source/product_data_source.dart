import 'package:dio/dio.dart';
import 'package:nike_app/common/error_handling/check_exceptions.dart';
import 'package:nike_app/features/feature_prodcut/data/model/product.dart';

abstract class IProductDataSource {
  Future<List<ProductModel>> getAll(int sort);
  Future<List<ProductModel>> search(String searchTerm);
}

class ProductRemoteDataSource extends IProductDataSource {
  final Dio dio;

  ProductRemoteDataSource(this.dio);
  @override
  Future<List<ProductModel>> getAll(int sort) async {
    try {
      var response = await dio.get('product/list?sort=$sort');
      List<ProductModel> productList = response.data
          .map<ProductModel>((product) => ProductModel.fromJson(product))
          .toList();
      return productList;
    } on DioError catch (e) {
      return CheckException.response(e.response!);
    }
  }

  @override
  Future<List<ProductModel>> search(String searchTerm) async {
    try {
      var response = await dio.get('product/search?q=$searchTerm');
      List<ProductModel> productList = response.data
          .map<ProductModel>((product) => ProductModel.fromJson(product))
          .toList();
      return productList;
    } on DioError catch (e) {
      return CheckException.response(e.response!);
    }
  }
}
