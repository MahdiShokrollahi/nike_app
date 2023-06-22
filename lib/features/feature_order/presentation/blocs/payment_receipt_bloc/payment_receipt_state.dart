// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'payment_receipt_bloc.dart';

class PaymentReceiptState extends Equatable {
  PaymentReceiptDataStatus paymentReceiptDataStatus;
  PaymentReceiptState({
    required this.paymentReceiptDataStatus,
  });

  PaymentReceiptState copyWith(
      {PaymentReceiptDataStatus? newPaymentReceiptDataStatus}) {
    return PaymentReceiptState(
        paymentReceiptDataStatus:
            newPaymentReceiptDataStatus ?? paymentReceiptDataStatus);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [paymentReceiptDataStatus];
}
