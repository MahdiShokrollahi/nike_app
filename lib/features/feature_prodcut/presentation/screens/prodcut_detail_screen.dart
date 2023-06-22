import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_app/common/arguments/product_detail_argument.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:nike_app/common/extensions/int_extension.dart';
import 'package:nike_app/common/utils/custom_snackbar.dart';
import 'package:nike_app/common/utils/favorite_manager.dart';
import 'package:nike_app/common/utils/theme_color.dart';
import 'package:nike_app/common/widgets/cached_images.dart';
import 'package:nike_app/features/feature_prodcut/data/model/product.dart';
import 'package:nike_app/features/feature_prodcut/presentation/blocs/product_add_to_cart_bloc/product_add_to_cart_bloc.dart';
import 'package:nike_app/features/feature_prodcut/presentation/widgets/comment_list.dart';
import 'package:nike_app/features/feature_prodcut/presentation/widgets/insert_comment_dialog.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product_detail_screen';
  ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFabVisible = true;

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)!.settings.arguments as ProductDetailArgument;
    final favoriteManger = locator<FavoriteManger>();
    return BlocProvider(
      create: (context) => ProductAddToCartBloc(locator()),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            BlocConsumer<ProductAddToCartBloc, ProductAddTOCartState>(
          listener: (context, state) {
            if (state.productAddToCartDataStatus
                is ProductAddToCartDataSuccess) {
              ProductAddToCartDataSuccess productAddToCartDataSuccess = state
                  .productAddToCartDataStatus as ProductAddToCartDataSuccess;
              CustomSnackbar.showSnackbar(context,
                  message: 'با موفقیت به سبد خرید شما اضافه شد');
            }
            if (state.productAddToCartDataStatus is ProductAddToCartDataError) {
              ProductAddToCartDataError productAddToCartDataError =
                  state.productAddToCartDataStatus as ProductAddToCartDataError;
              CustomSnackbar.showSnackbar(context,
                  message: productAddToCartDataError.error);
            }
          },
          builder: (context, state) {
            return Visibility(
              visible: isFabVisible,
              child: FadeInUp(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width - 48,
                    child: FloatingActionButton.extended(
                        onPressed: () {
                          BlocProvider.of<ProductAddToCartBloc>(context)
                              .add(ProductAddToCartClicked(arg.product.id));
                        },
                        label: (state.productAddToCartDataStatus
                                is ProductAddToCartDataLoading)
                            ? CupertinoActivityIndicator(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              )
                            : const Text('افزودن به سبد خرید'))),
              ),
            );
          },
        ),
        body: SafeArea(
          top: true,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                setState(() {
                  if (notification.direction == ScrollDirection.forward) {
                    isFabVisible = true;
                  }
                  if (notification.direction == ScrollDirection.reverse) {
                    isFabVisible = false;
                  }
                });
                return true;
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.width * 0.8,
                    flexibleSpace: Hero(
                        tag: arg.heroTag,
                        child: CachedImage(imageUrl: arg.product.imageUrl)),
                    foregroundColor: LightThemeColors.primaryTextColor,
                    actions: [
                      IconButton(
                        icon: Icon(favoriteManger.isFavorite(arg.product)
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart),
                        onPressed: () {
                          if (!favoriteManger.isFavorite(arg.product)) {
                            favoriteManger.addFavorite(arg.product);
                          } else {
                            favoriteManger.delete(arg.product);
                          }
                          setState(() {});
                        },
                      )
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          FadeInDown(
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  arg.product.title,
                                  style: Theme.of(context).textTheme.titleLarge,
                                )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      arg.product.previousPrice.withPriceLabel,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .apply(
                                              decoration:
                                                  TextDecoration.lineThrough),
                                    ),
                                    Text(arg.product.price.withPriceLabel),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          FadeInDown(
                            child: const Text(
                              'این کتونی شدیدا برای دویدن و راه رفتن مناسب هست و تقریبا هیچ فشار مخربی رو نمیذارد به پا و زانوان شما انتقال داده شود.',
                              style: TextStyle(height: 1.4),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: CommentHeader(arg.product)),
                  CommentList(
                    product: arg.product,
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

class CommentHeader extends SliverPersistentHeaderDelegate {
  final ProductModel product;

  CommentHeader(this.product);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return FadeInDown(
      child: Padding(
        padding: const EdgeInsets.only(right: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'نظرات کاربران',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16))),
                      builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: InsertCommentDialog(
                              productId: product.id,
                            ),
                          ));
                },
                child: const Text('ثبت نظر'))
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 80;

  @override
  // TODO: implement minExtent
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }
}
