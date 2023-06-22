import 'package:dartz/dartz.dart';
import 'package:nike_app/common/error_handling/app_exceptions.dart';
import 'package:nike_app/common/error_handling/check_exceptions.dart';
import 'package:nike_app/common/params/order_params.dart';
import 'package:nike_app/features/feature_order/data/data_source/order_data_status.dart';

abstract class IOrderRepository {
  Future<dynamic> create(CreateOrderParams params);
  Future<dynamic> getPaymentReceipt(int orderId);
  Future<dynamic> getOrder();
}

class OrderRepository implements IOrderRepository {
  final IOrderDataSource dataSource;

  OrderRepository(this.dataSource);
  @override
  Future<dynamic> create(CreateOrderParams params) async {
    try {
      var response = await dataSource.create(params);
      return right(response);
    } on AppException catch (e) {
      return CheckException.getError(e);
    }
  }

  @override
  Future getPaymentReceipt(int orderId) async {
    try {
      var response = await dataSource.getPaymentReceipt(orderId);
      return right(response);
    } on AppException catch (e) {
      return CheckException.getError(e);
    }
  }

  @override
  Future getOrder() async {
    try {
      var orderList = await dataSource.getOrder();
      return right(orderList);
    } on AppException catch (e) {
      return CheckException.getError(e);
    }
  }
}
