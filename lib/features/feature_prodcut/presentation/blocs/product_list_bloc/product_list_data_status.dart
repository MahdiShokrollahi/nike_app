import 'package:equatable/equatable.dart';
import 'package:nike_app/features/feature_prodcut/data/model/product.dart';

abstract class ProductListDataStatus extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductListDataLoading extends ProductListDataStatus {}

class ProductListDataSuccess extends ProductListDataStatus {
  final List<ProductModel> productList;
  final int sort;
  final List<String> sortName;

  ProductListDataSuccess(this.productList, this.sort, this.sortName);

  @override
  // TODO: implement props
  List<Object?> get props => [productList, sort, sortName];
}

class ProductListDataEmpty extends ProductListDataStatus {
  final String message;

  ProductListDataEmpty(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class ProductListDataError extends ProductListDataStatus {
  final String error;

  ProductListDataError(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
