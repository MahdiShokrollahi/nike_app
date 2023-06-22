part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartStarted extends CartEvent {
  final AuthInfo? authInfo;
  final bool isRefreshing;

  const CartStarted(this.authInfo, {this.isRefreshing = false});
}

class CartDeleteButtonClicked extends CartEvent {
  final int cartItemID;

  const CartDeleteButtonClicked(this.cartItemID);

  @override
  // TODO: implement props
  List<Object?> get props => [cartItemID];
}

class CartAuthInfoChanged extends CartEvent {
  final AuthInfo? authInfo;

  const CartAuthInfoChanged(this.authInfo);
}

class CartIncreaseCountButtonClicked extends CartEvent {
  final int cartItemID;

  const CartIncreaseCountButtonClicked(this.cartItemID);

  @override
  // TODO: implement props
  List<Object?> get props => [cartItemID];
}

class CartDecreaseCountButtonClicked extends CartEvent {
  final int cartItemID;

  const CartDecreaseCountButtonClicked(this.cartItemID);
  @override
  // TODO: implement props
  List<Object?> get props => [cartItemID];
}
