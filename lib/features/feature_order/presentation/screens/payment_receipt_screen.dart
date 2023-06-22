import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:nike_app/common/extensions/int_extension.dart';
import 'package:nike_app/common/utils/theme_color.dart';
import 'package:nike_app/features/feature_order/presentation/blocs/payment_receipt_bloc/payment_data_status.dart';
import 'package:nike_app/features/feature_order/presentation/blocs/payment_receipt_bloc/payment_receipt_bloc.dart';

class PaymentReceiptScreen extends StatelessWidget {
  const PaymentReceiptScreen({super.key});

  static const routeName = '/payment_receipt_screen';
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final orderId = ModalRoute.of(context)!.settings.arguments as int;
    return BlocProvider(
      create: (context) {
        var bloc = PaymentReceiptBloc(locator());
        bloc.add(PaymentReceiptStarted(orderId));
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('رسید پرداخت'),
          centerTitle: true,
        ),
        body: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
          builder: (context, state) {
            if (state.paymentReceiptDataStatus is PaymentReceiptDataLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.paymentReceiptDataStatus is PaymentReceiptDataSuccess) {
              PaymentReceiptDataSuccess paymentReceiptDataSuccess =
                  state.paymentReceiptDataStatus as PaymentReceiptDataSuccess;
              final paymentReceiptData =
                  paymentReceiptDataSuccess.paymentReceiptData;
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: themeData.dividerColor),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Text(
                            paymentReceiptData.purchaseSuccess
                                ? 'پرداخت با موفقیت انجام شد'
                                : 'پرداخت ناموفق',
                            style: themeData.textTheme.titleLarge!.apply(
                              color: themeData.colorScheme.primary,
                            )),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('وضیعت سفارش',
                                style: TextStyle(
                                  color: LightThemeColors.secondaryTextColor,
                                )),
                            Text(paymentReceiptData.paymentStatus,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold))
                          ],
                        ),
                        const Divider(
                          height: 32,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('مبلغ',
                                style: TextStyle(
                                  color: LightThemeColors.secondaryTextColor,
                                )),
                            Text(paymentReceiptData.payablePrice.withPriceLabel,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text('بازگشت به صفحه اصلی'))
                ],
              );
            }
            if (state.paymentReceiptDataStatus is PaymentReceiptDataError) {
              PaymentReceiptDataError paymentReceiptDataError =
                  state.paymentReceiptDataStatus as PaymentReceiptDataError;
              return Center(child: Text(paymentReceiptDataError.error));
            }
            return const Text('state is not valid');
          },
        ),
      ),
    );
  }
}
