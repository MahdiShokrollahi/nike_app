import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_app/features/feature_cart/data/model/add_to_cart.dart';
import 'package:nike_app/features/feature_cart/data/repository/cart_repository.dart';

part 'product_add_to_cart_event.dart';
part 'product_add_to_cart_state.dart';
part 'product_add_to_cart_data_status.dart';

class ProductAddToCartBloc
    extends Bloc<ProductAddTOCartEvent, ProductAddTOCartState> {
  final ICartRepository cartRepository;
  ProductAddToCartBloc(this.cartRepository)
      : super(ProductAddTOCartState(
            productAddToCartDataStatus: ProductAddTOCartDataInitial())) {
    on<ProductAddToCartClicked>((event, emit) async {
      emit(state.copyWith(
          newProductAddToCartDataStatus: ProductAddToCartDataLoading()));
      var result = await cartRepository.add(event.productId);
      await cartRepository.count();
      result.fold((error) {
        emit(state.copyWith(
            newProductAddToCartDataStatus: ProductAddToCartDataError(error)));
      }, (cartModel) {
        emit(state.copyWith(
            newProductAddToCartDataStatus:
                ProductAddToCartDataSuccess(cartModel)));
      });
    });
  }
}
