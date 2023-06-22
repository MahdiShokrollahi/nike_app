import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_app/features/feature_order/data/model/order.dart';
import 'package:nike_app/features/feature_order/data/repository/order_repository.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final IOrderRepository orderRepository;
  OrderHistoryBloc(this.orderRepository) : super(OrderHistoryLoading()) {
    on<OrderHistoryStarted>((event, emit) async {
      emit(OrderHistoryLoading());
      final result = await orderRepository.getOrder();
      result.fold((error) {
        emit(OrderHistoryError(error));
      }, (orderList) {
        emit(OrderHistorySuccess(orderList));
      });
    });
  }
}
