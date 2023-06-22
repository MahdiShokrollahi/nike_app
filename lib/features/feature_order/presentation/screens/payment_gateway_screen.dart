import 'package:flutter/material.dart';
import 'package:nike_app/features/feature_order/presentation/screens/payment_receipt_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGatewayScreen extends StatelessWidget {
  PaymentGatewayScreen({super.key});
  static const routeName = '/payment_gateway_screen';

  @override
  Widget build(BuildContext context) {
    final bankGateWayUrl = ModalRoute.of(context)!.settings.arguments as String;
    return WebView(
      initialUrl: bankGateWayUrl,
      onPageStarted: (url) {
        debugPrint('url:$url');
        final uri = Uri.parse(url);
        if (uri.pathSegments.contains('checkout') &&
            uri.host == 'expertdevelopers.ir') {
          final orderId = int.parse(uri.queryParameters['order_id']!);
          Navigator.of(context).pop();
          Navigator.pushNamed(context, PaymentReceiptScreen.routeName,
              arguments: orderId);
        }
      },
    );
  }
}
