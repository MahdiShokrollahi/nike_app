import 'package:dio/dio.dart';
import 'package:nike_app/common/enums/payment_method.dart';
import 'package:nike_app/common/error_handling/check_exceptions.dart';
import 'package:nike_app/common/params/order_params.dart';
import 'package:nike_app/features/feature_order/data/model/creeat_order.dart';
import 'package:nike_app/features/feature_order/data/model/order.dart';
import 'package:nike_app/features/feature_order/data/model/payment_reciept.dart';

abstract class IOrderDataSource {
  Future<CreateOrderModel> create(CreateOrderParams params);
  Future<PaymentReceiptData> getPaymentReceipt(int orderId);
  Future<List<OrderModel>> getOrder();
}

class OrderRemoteDataSource implements IOrderDataSource {
  final Dio dio;

  OrderRemoteDataSource(this.dio);

  @override
  Future<CreateOrderModel> create(CreateOrderParams params) async {
    try {
      var response = await dio.post('order/submit', data: {
        'first_name': params.firstName,
        'last_name': params.lastName,
        'mobile': params.phoneNumber,
        'postal_code': params.postalCode,
        'address': params.address,
        'payment_method': params.paymentMethod == PaymentMethod.online
            ? 'online'
            : 'cash_on_delivery'
      });
      final createOrderModel = CreateOrderModel.fromJson(response.data);
      return createOrderModel;
    } on DioError catch (e) {
      return CheckException.response(e.response!);
    }
  }

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderId) async {
    try {
      var response = await dio.get('order/checkout?order_id=$orderId');
      final paymentReceiptData = PaymentReceiptData.fromJson(response.data);
      return paymentReceiptData;
    } on DioError catch (e) {
      return CheckException.response(e.response!);
    }
  }

  @override
  Future<List<OrderModel>> getOrder() async {
    try {
      var response = await dio.get('order/list');
      List<OrderModel> orderList = response.data
          .map<OrderModel>((item) => OrderModel.fromJson(item))
          .toList();
      return orderList;
    } on DioError catch (e) {
      return CheckException.response(e.response!);
    }
  }
}
