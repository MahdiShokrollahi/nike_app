import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nike_app/common/extensions/int_extension.dart';
import 'package:nike_app/common/utils/constants.dart';
import 'package:nike_app/common/utils/favorite_manager.dart';
import 'package:nike_app/common/widgets/background_dismissible.dart';
import 'package:nike_app/common/widgets/cached_images.dart';
import 'package:nike_app/features/feature_prodcut/data/model/product.dart';
import 'package:nike_app/features/feature_prodcut/presentation/screens/prodcut_detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});
  static const routeName = '/favorite_screen';
  @override
  Widget build(BuildContext context) {
    final FavoriteManger favoriteManger = FavoriteManger();
    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست علاقه مندی ها'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<ProductModel>>(
          valueListenable: favoriteManger.listenable,
          builder: (context, box, child) {
            final products = box.values.toList();
            return Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.builder(
                  itemCount: products.length,
                  padding: const EdgeInsets.only(top: 8, bottom: 100),
                  physics: Constants.defaultScrollPhysic,
                  itemBuilder: (context, index) {
                    var product = products[index];
                    return Dismissible(
                      key: UniqueKey(),
                      background: const BackgroundDismissible(),
                      onDismissed: (direction) {
                        favoriteManger.delete(product);
                      },
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, ProductDetailScreen.routeName,
                              arguments: product);
                        },
                        child: ZoomIn(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                            child: Row(
                              children: [
                                SizedBox(
                                    height: 110,
                                    width: 110,
                                    child: CachedImage(
                                      imageUrl: product.imageUrl,
                                      borderRadius: 8,
                                    )),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        Text(
                                          product.previousPrice.withPriceLabel,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        Text(
                                          product.price.withPriceLabel,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }),
    );
  }
}
