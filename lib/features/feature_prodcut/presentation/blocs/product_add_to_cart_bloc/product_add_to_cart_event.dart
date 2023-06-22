part of 'product_add_to_cart_bloc.dart';

abstract class ProductAddTOCartEvent extends Equatable {
  const ProductAddTOCartEvent();

  @override
  List<Object> get props => [];
}

class ProductAddToCartClicked extends ProductAddTOCartEvent {
  final int productId;

  const ProductAddToCartClicked(this.productId);
}
