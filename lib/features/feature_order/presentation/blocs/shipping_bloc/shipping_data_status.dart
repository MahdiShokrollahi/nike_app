import 'package:equatable/equatable.dart';
import 'package:nike_app/features/feature_order/data/model/creeat_order.dart';

abstract class ShippingDataStatus extends Equatable {
  @override
  List<Object> get props => [];
}

class ShippingDataInitial extends ShippingDataStatus {}

class ShippingDataLoading extends ShippingDataStatus {}

class ShippingDataError extends ShippingDataStatus {
  final String error;

  ShippingDataError(this.error);

  @override
  List<Object> get props => [error];
}

class ShippingDataSuccess extends ShippingDataStatus {
  final CreateOrderModel createOrderModel;

  ShippingDataSuccess(this.createOrderModel);

  @override
  List<Object> get props => [createOrderModel];
}
