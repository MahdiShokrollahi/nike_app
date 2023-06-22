class CreateOrderModel {
  final int orderId;
  final String bankGateWayUrl;

  CreateOrderModel.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGateWayUrl = json['bank_gateway_url'];
}
