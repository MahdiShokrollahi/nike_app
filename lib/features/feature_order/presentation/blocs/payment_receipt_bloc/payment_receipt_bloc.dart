import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_app/features/feature_order/data/repository/order_repository.dart';
import 'package:nike_app/features/feature_order/presentation/blocs/payment_receipt_bloc/payment_data_status.dart';

part 'payment_receipt_event.dart';
part 'payment_receipt_state.dart';

class PaymentReceiptBloc
    extends Bloc<PaymentReceiptEvent, PaymentReceiptState> {
  final IOrderRepository orderRepository;
  PaymentReceiptBloc(this.orderRepository)
      : super(PaymentReceiptState(
            paymentReceiptDataStatus: PaymentReceiptDataLoading())) {
    on<PaymentReceiptStarted>((event, emit) async {
      emit(state.copyWith(
          newPaymentReceiptDataStatus: PaymentReceiptDataLoading()));
      var result = await orderRepository.getPaymentReceipt(event.orderId);
      result.fold((error) {
        emit(state.copyWith(
            newPaymentReceiptDataStatus: PaymentReceiptDataError(error)));
      }, (paymentReceiptData) {
        emit(state.copyWith(
            newPaymentReceiptDataStatus:
                PaymentReceiptDataSuccess(paymentReceiptData)));
      });
    });
  }
}
