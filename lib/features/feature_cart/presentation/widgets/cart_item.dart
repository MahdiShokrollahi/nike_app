import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_app/common/extensions/int_extension.dart';
import 'package:nike_app/common/utils/theme_color.dart';
import 'package:nike_app/common/widgets/cached_images.dart';
import 'package:nike_app/features/feature_cart/data/model/cart_item.dart';
import 'package:nike_app/features/feature_cart/presentation/blocs/cart_bloc/cart_bloc.dart';

class CartItem extends StatelessWidget {
  final CartItemModel cartItem;
  const CartItem({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
            ]),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CachedImage(
                    imageUrl: cartItem.product.imageUrl,
                    borderRadius: 4,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    cartItem.product.title,
                    style: const TextStyle(fontSize: 16),
                  ),
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('تعداد'),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              BlocProvider.of<CartBloc>(context).add(
                                  CartIncreaseCountButtonClicked(cartItem.id));
                            },
                            icon: const Icon(CupertinoIcons.plus_rectangle)),
                        cartItem.changeCountLoading
                            ? CupertinoActivityIndicator(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )
                            : Text(
                                cartItem.count.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                        IconButton(
                          onPressed: () {
                            if (cartItem.count > 1) {
                              BlocProvider.of<CartBloc>(context).add(
                                  CartDecreaseCountButtonClicked(cartItem.id));
                            }
                          },
                          icon: const Icon(CupertinoIcons.minus_rectangle),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      cartItem.product.previousPrice.withPriceLabel,
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12,
                        color: LightThemeColors.secondaryTextColor,
                      ),
                    ),
                    Text(cartItem.product.price.withPriceLabel),
                  ],
                )
              ],
            ),
            const Divider(
              height: 1,
            ),
            cartItem.deleteButtonLoading
                ? const SizedBox(
                    height: 48,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      BlocProvider.of<CartBloc>(context)
                          .add(CartDeleteButtonClicked(cartItem.id));
                    },
                    child: const Text('حذف از سبد خرید'))
          ],
        ),
      ),
    );
  }
}
