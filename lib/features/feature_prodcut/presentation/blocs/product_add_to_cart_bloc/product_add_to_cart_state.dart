// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_add_to_cart_bloc.dart';

class ProductAddTOCartState extends Equatable {
  ProductAddToCartDataStatus productAddToCartDataStatus;
  ProductAddTOCartState({
    required this.productAddToCartDataStatus,
  });

  ProductAddTOCartState copyWith(
      {ProductAddToCartDataStatus? newProductAddToCartDataStatus}) {
    return ProductAddTOCartState(
        productAddToCartDataStatus:
            newProductAddToCartDataStatus ?? productAddToCartDataStatus);
  }

  @override
  List<Object> get props => [productAddToCartDataStatus];
}
