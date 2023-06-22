import 'package:equatable/equatable.dart';
import 'package:nike_app/features/feature_order/data/model/payment_reciept.dart';

abstract class PaymentReceiptDataStatus extends Equatable {
  @override
  List<Object> get props => [];
}

class PaymentReceiptDataLoading extends PaymentReceiptDataStatus {}

class PaymentReceiptDataError extends PaymentReceiptDataStatus {
  final String error;

  PaymentReceiptDataError(this.error);

  @override
  List<Object> get props => [error];
}

class PaymentReceiptDataSuccess extends PaymentReceiptDataStatus {
  final PaymentReceiptData paymentReceiptData;

  PaymentReceiptDataSuccess(this.paymentReceiptData);

  @override
  List<Object> get props => [paymentReceiptData];
}
