import 'package:nike_app/features/feature_cart/data/model/cart_response.dart';

abstract class CartDataStatus {
  const CartDataStatus();
}

class CartDataLoading extends CartDataStatus {}

class CartDataSuccess extends CartDataStatus {
  final CartResponse cartResponse;
  CartDataSuccess(this.cartResponse);
}

class CartDataError extends CartDataStatus {
  final String error;

  CartDataError(this.error);
}

class CartEmpty extends CartDataStatus {}

class CartAuthRequired extends CartDataStatus {}
