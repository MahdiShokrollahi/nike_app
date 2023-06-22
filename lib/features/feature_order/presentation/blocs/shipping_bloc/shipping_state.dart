// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'shipping_bloc.dart';

class ShippingState extends Equatable {
  ShippingDataStatus shippingDataStatus;
  ShippingState({
    required this.shippingDataStatus,
  });

  ShippingState copyWith({ShippingDataStatus? newShippingDataStatus}) {
    return ShippingState(
        shippingDataStatus: newShippingDataStatus ?? shippingDataStatus);
  }

  @override
  List<Object> get props => [shippingDataStatus];
}
