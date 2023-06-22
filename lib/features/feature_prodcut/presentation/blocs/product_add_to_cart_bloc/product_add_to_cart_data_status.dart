part of 'product_add_to_cart_bloc.dart';

abstract class ProductAddToCartDataStatus extends Equatable {}

class ProductAddTOCartDataInitial extends ProductAddToCartDataStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductAddToCartDataLoading extends ProductAddToCartDataStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductAddToCartDataSuccess extends ProductAddToCartDataStatus {
  final AddToCartModel cartModel;

  ProductAddToCartDataSuccess(this.cartModel);

  @override
  // TODO: implement props
  List<Object?> get props => [cartModel];
}

class ProductAddToCartDataError extends ProductAddToCartDataStatus {
  final String error;

  ProductAddToCartDataError(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
