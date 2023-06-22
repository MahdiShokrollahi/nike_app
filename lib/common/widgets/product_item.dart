// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_app/common/arguments/product_detail_argument.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:nike_app/common/extensions/int_extension.dart';
import 'package:nike_app/common/utils/favorite_manager.dart';
import 'package:nike_app/common/widgets/cached_images.dart';

import 'package:nike_app/features/feature_prodcut/data/model/product.dart';
import 'package:nike_app/features/feature_prodcut/presentation/screens/prodcut_detail_screen.dart';

class ProductItem extends StatefulWidget {
  final ProductModel product;
  final bool isFavorite;
  final double borderRadius;
  final String heroTag;
  const ProductItem({
    Key? key,
    required this.product,
    required this.borderRadius,
    required this.isFavorite,
    required this.heroTag,
  }) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final favoriteManger = locator<FavoriteManger>();
    return ZoomIn(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          onTap: () {
            Navigator.pushNamed(context, ProductDetailScreen.routeName,
                arguments:
                    ProductDetailArgument(widget.product, widget.heroTag));
          },
          child: SizedBox(
            width: 176,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: widget.heroTag,
                      child: AspectRatio(
                          aspectRatio: 0.93,
                          child: CachedImage(
                              imageUrl: widget.product.imageUrl,
                              borderRadius: widget.borderRadius)),
                    ),
                    Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: () {
                            if (!favoriteManger.isFavorite(widget.product)) {
                              favoriteManger.addFavorite(widget.product);
                            } else {
                              favoriteManger.delete(widget.product);
                            }
                            setState(() {});
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(
                              widget.isFavorite
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              size: 20,
                            ),
                          ),
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Text(
                    widget.product.previousPrice.withPriceLabel,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(decoration: TextDecoration.lineThrough),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                  child: Text(widget.product.price.withPriceLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
