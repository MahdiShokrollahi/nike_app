import 'package:dartz/dartz.dart';
import 'package:nike_app/common/error_handling/app_exceptions.dart';
import 'package:nike_app/common/error_handling/check_exceptions.dart';
import 'package:nike_app/features/feature_prodcut/data/data_source/product_data_source.dart';

abstract class IProductRepository {
  Future<dynamic> getAll(int sort);
  Future<dynamic> search(String searchTerm);
}

class ProductRepository extends IProductRepository {
  final IProductDataSource productDataSource;

  ProductRepository(this.productDataSource);
  @override
  Future<dynamic> getAll(int sort) async {
    try {
      var response = await productDataSource.getAll(sort);
      return right(response);
    } on AppException catch (e) {
      return CheckException.getError(e);
    }
  }

  @override
  Future<dynamic> search(String searchTerm) async {
    try {
      var response = await productDataSource.search(searchTerm);
      return right(response);
    } on AppException catch (e) {
      return CheckException.getError(e);
    }
  }
}
