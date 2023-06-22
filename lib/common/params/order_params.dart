import 'package:nike_app/common/enums/payment_method.dart';

class CreateOrderParams {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String postalCode;
  final String address;
  final PaymentMethod paymentMethod;

  CreateOrderParams(this.firstName, this.lastName, this.phoneNumber,
      this.postalCode, this.address, this.paymentMethod);
}
