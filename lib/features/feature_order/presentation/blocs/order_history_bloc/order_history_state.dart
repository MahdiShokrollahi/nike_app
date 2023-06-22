part of 'order_history_bloc.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistorySuccess extends OrderHistoryState {
  final List<OrderModel> orderList;

  const OrderHistorySuccess(this.orderList);

  @override
  List<Object> get props => [orderList];
}

class OrderHistoryError extends OrderHistoryState {
  final String error;

  const OrderHistoryError(this.error);
  @override
  List<Object> get props => [error];
}
