import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_app/features/feature_auth/data/model/auth_info.dart';
import 'package:nike_app/features/feature_cart/data/model/cart_response.dart';
import 'package:nike_app/features/feature_cart/data/repository/cart_repository.dart';
import 'package:nike_app/features/feature_cart/presentation/blocs/cart_bloc/cart_data_status.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;
  CartBloc(this.cartRepository)
      : super(CartState(cartDataStatus: CartDataLoading())) {
    on<CartStarted>((event, emit) async {
      final authInfo = event.authInfo;
      if (authInfo == null || authInfo.accessToken.isEmpty) {
        emit(state.copyWith(newCartDataStatus: CartAuthRequired()));
      } else {
        await loadCartItems(emit, event.isRefreshing);
      }
    });

    on<CartDeleteButtonClicked>((event, emit) async {
      try {
        if (state.cartDataStatus is CartDataSuccess) {
          CartDataSuccess cartDataSuccess =
              state.cartDataStatus as CartDataSuccess;
          final index = cartDataSuccess.cartResponse.cartItems
              .indexWhere((element) => element.id == event.cartItemID);
          cartDataSuccess.cartResponse.cartItems[index].deleteButtonLoading =
              true;
          emit(state.copyWith(
              newCartDataStatus:
                  CartDataSuccess(cartDataSuccess.cartResponse)));
        }

        Future.delayed(const Duration(milliseconds: 2000));
        await cartRepository.delete(event.cartItemID);
        await cartRepository.count();
        if (state.cartDataStatus is CartDataSuccess) {
          CartDataSuccess cartDataSuccess =
              state.cartDataStatus as CartDataSuccess;
          cartDataSuccess.cartResponse.cartItems
              .removeWhere((element) => element.id == event.cartItemID);
          if (cartDataSuccess.cartResponse.cartItems.isEmpty) {
            emit(state.copyWith(newCartDataStatus: CartEmpty()));
          } else {
            emit(state.copyWith(
                newCartDataStatus:
                    calculatePriceInfo(cartDataSuccess.cartResponse)));
          }
        }
      } catch (e) {
        emit(state.copyWith(newCartDataStatus: CartDataError(e.toString())));
      }
    });

    on<CartAuthInfoChanged>((event, emit) async {
      if (event.authInfo == null || event.authInfo!.accessToken.isEmpty) {
        emit(state.copyWith(newCartDataStatus: CartAuthRequired()));
      } else {
        if (state.cartDataStatus is CartAuthRequired) {
          await loadCartItems(emit, false);
        }
      }
    });

    on<CartEvent>((event, emit) async {
      if (event is CartIncreaseCountButtonClicked ||
          event is CartDecreaseCountButtonClicked) {
        try {
          int cartItemID = 0;
          if (event is CartIncreaseCountButtonClicked) {
            cartItemID = event.cartItemID;
          } else if (event is CartDecreaseCountButtonClicked) {
            cartItemID = event.cartItemID;
          }
          if (state.cartDataStatus is CartDataSuccess) {
            CartDataSuccess cartDataSuccess =
                state.cartDataStatus as CartDataSuccess;
            final index = cartDataSuccess.cartResponse.cartItems
                .indexWhere((element) => element.id == cartItemID);
            cartDataSuccess.cartResponse.cartItems[index].changeCountLoading =
                true;
            emit(state.copyWith(
                newCartDataStatus:
                    CartDataSuccess(cartDataSuccess.cartResponse)));

            Future.delayed(const Duration(milliseconds: 2000));

            int newCount = event is CartIncreaseCountButtonClicked
                ? ++cartDataSuccess.cartResponse.cartItems[index].count
                : --cartDataSuccess.cartResponse.cartItems[index].count;
            await cartRepository.changeCount(cartItemID, newCount);
            await cartRepository.count();

            cartDataSuccess.cartResponse.cartItems
                .firstWhere((element) => element.id == cartItemID)
              ..count = newCount
              ..changeCountLoading = false;

            emit(state.copyWith(
                newCartDataStatus:
                    calculatePriceInfo(cartDataSuccess.cartResponse)));
          }
        } catch (e) {
          emit(state.copyWith(newCartDataStatus: CartDataError(e.toString())));
        }
      }
    });
  }

  Future<void> loadCartItems(Emitter<CartState> emit, bool isRefreshing) async {
    if (!isRefreshing) {
      emit(state.copyWith(newCartDataStatus: CartDataLoading()));
    }
    final result = await cartRepository.getAll();
    result.fold((error) {
      emit(state.copyWith(newCartDataStatus: CartDataError(error)));
    }, (cartResponse) {
      var cart = cartResponse as CartResponse;
      if (cart.cartItems.isEmpty) {
        emit(state.copyWith(newCartDataStatus: CartEmpty()));
      } else {
        emit(state.copyWith(newCartDataStatus: CartDataSuccess(cart)));
      }
    });
  }

  CartDataSuccess calculatePriceInfo(CartResponse cartResponse) {
    var payablePrice = 0;
    var shippingPrice = 0;
    var totalPrice = 0;

    for (var cartItem in cartResponse.cartItems) {
      totalPrice += cartItem.product.previousPrice * cartItem.count;
      payablePrice += cartItem.product.price * cartItem.count;
    }
    shippingPrice = payablePrice >= 250000 ? 0 : 30000;
    cartResponse.payablePrice = payablePrice;
    cartResponse.totalPrice = totalPrice;
    cartResponse.shippingCost = shippingPrice;
    return CartDataSuccess(cartResponse);
  }
}
