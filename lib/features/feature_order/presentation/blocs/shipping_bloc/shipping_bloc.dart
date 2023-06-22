import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_app/common/params/order_params.dart';
import 'package:nike_app/features/feature_order/data/repository/order_repository.dart';
import 'package:nike_app/features/feature_order/presentation/blocs/shipping_bloc/shipping_data_status.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final IOrderRepository orderRepository;
  ShippingBloc(this.orderRepository)
      : super(ShippingState(shippingDataStatus: ShippingDataInitial())) {
    on<ShippingCreateOrder>((event, emit) async {
      emit(state.copyWith(newShippingDataStatus: ShippingDataLoading()));
      final result = await orderRepository.create(event.params);
      result.fold((error) {
        emit(state.copyWith(newShippingDataStatus: ShippingDataError(error)));
      }, (createOrderModel) {
        emit(state.copyWith(
            newShippingDataStatus: ShippingDataSuccess(createOrderModel)));
      });
    });
  }
}
