import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_app/common/arguments/price_argument.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:nike_app/common/enums/payment_method.dart';
import 'package:nike_app/common/params/order_params.dart';
import 'package:nike_app/common/utils/custom_snackbar.dart';
import 'package:nike_app/features/feature_cart/presentation/widgets/price_info.dart';
import 'package:nike_app/features/feature_order/presentation/blocs/shipping_bloc/shipping_bloc.dart';
import 'package:nike_app/features/feature_order/presentation/blocs/shipping_bloc/shipping_data_status.dart';
import 'package:nike_app/features/feature_order/presentation/screens/payment_gateway_screen.dart';
import 'package:nike_app/features/feature_order/presentation/screens/payment_receipt_screen.dart';

class ShippingScreen extends StatelessWidget {
  ShippingScreen({
    super.key,
  });

  static const routeName = '/shipping_screen';

  final TextEditingController firstNameController =
      TextEditingController(text: 'مهدی');

  final TextEditingController lastNameController =
      TextEditingController(text: 'شکرالهی');

  final TextEditingController phoneNumberController =
      TextEditingController(text: '09115652791');

  final TextEditingController postalCodeController =
      TextEditingController(text: '6881865696');

  final TextEditingController addressController =
      TextEditingController(text: ' مازندران تنکابن خیابان شهید محمدی');
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as PriceArgument;

    return BlocProvider(
      create: (context) => ShippingBloc(locator()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('تحویل گیرنده'),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      label: Text('نام'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      label: Text('نام خانوادگی'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      label: Text('شماره تماس'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller: postalCodeController,
                    decoration: const InputDecoration(
                      label: Text('کد پستی'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      label: Text('آدرس'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  PriceInfo(
                      payablePrice: arg.payablePrice,
                      shippingCost: arg.shippingCost,
                      totalPrice: arg.totalPrice),
                  BlocConsumer<ShippingBloc, ShippingState>(
                    listener: (context, state) {
                      if (state.shippingDataStatus is ShippingDataSuccess) {
                        ShippingDataSuccess shippingDataSuccess =
                            state.shippingDataStatus as ShippingDataSuccess;
                        if (shippingDataSuccess
                            .createOrderModel.bankGateWayUrl.isNotEmpty) {
                          Navigator.pushNamed(
                              context, PaymentGatewayScreen.routeName,
                              arguments: shippingDataSuccess
                                  .createOrderModel.bankGateWayUrl);
                        } else {
                          Navigator.pushNamed(
                              context, PaymentReceiptScreen.routeName,
                              arguments:
                                  shippingDataSuccess.createOrderModel.orderId);
                        }
                      }
                      if (state.shippingDataStatus is ShippingDataError) {
                        ShippingDataError shippingDataError =
                            state.shippingDataStatus as ShippingDataError;
                        CustomSnackbar.showSnackbar(context,
                            message: shippingDataError.error);
                      }
                    },
                    builder: (context, state) {
                      if (state.shippingDataStatus is ShippingDataLoading) {
                        return const CircularProgressIndicator();
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreateOrder(CreateOrderParams(
                                        firstNameController.text,
                                        lastNameController.text,
                                        phoneNumberController.text,
                                        postalCodeController.text,
                                        addressController.text,
                                        PaymentMethod.cashOnDelivery)));
                              },
                              child: Text('پرداخت در محل')),
                          const SizedBox(
                            width: 16,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreateOrder(CreateOrderParams(
                                        firstNameController.text,
                                        lastNameController.text,
                                        phoneNumberController.text,
                                        postalCodeController.text,
                                        addressController.text,
                                        PaymentMethod.online)));
                              },
                              child: Text('پرداخت اینترنتی'))
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
