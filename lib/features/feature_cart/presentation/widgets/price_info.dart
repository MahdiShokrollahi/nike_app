import 'package:flutter/material.dart';
import 'package:nike_app/common/extensions/int_extension.dart';
import 'package:nike_app/common/utils/theme_color.dart';

class PriceInfo extends StatelessWidget {
  const PriceInfo(
      {super.key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice});
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 8, 0),
          child:
              Text('جزئیات خرید', style: Theme.of(context).textTheme.subtitle1),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 32),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
              ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مبلغ کل خرید'),
                    RichText(
                        text: TextSpan(
                            text: totalPrice.withPriceLabel,
                            style: DefaultTextStyle.of(context).style.copyWith(
                                color: LightThemeColors.secondaryColor),
                            children: const [
                          TextSpan(
                              text: 'تومان', style: TextStyle(fontSize: 10))
                        ]))
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('هزینه ارسال'),
                    Text(shippingCost.withPriceLabel),
                  ],
                ),
              ),
              Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مبلغ قابل پرداخت'),
                    RichText(
                      text: TextSpan(
                        text: payablePrice.separateByComma,
                        style: DefaultTextStyle.of(context).style.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        children: const [
                          TextSpan(
                              text: ' تومان',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.normal))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
