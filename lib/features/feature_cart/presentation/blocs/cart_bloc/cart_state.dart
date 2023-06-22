part of 'cart_bloc.dart';

class CartState {
  CartDataStatus cartDataStatus;
  CartState({required this.cartDataStatus});

  CartState copyWith({CartDataStatus? newCartDataStatus}) {
    return CartState(cartDataStatus: newCartDataStatus ?? cartDataStatus);
  }
}
