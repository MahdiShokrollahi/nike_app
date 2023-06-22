import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nike_app/common/arguments/product_list_argument.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:nike_app/common/utils/constants.dart';
import 'package:nike_app/common/utils/favorite_manager.dart';
import 'package:nike_app/common/utils/theme_color.dart';
import 'package:nike_app/features/feature_prodcut/data/model/product.dart';
import 'package:nike_app/features/feature_home/data/repository/banner_repository.dart';
import 'package:nike_app/features/feature_home/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:nike_app/features/feature_home/presentation/blocs/home_bloc/home_data_status.dart';
import 'package:nike_app/features/feature_home/presentation/widgets/banner_slider.dart';
import 'package:nike_app/features/feature_prodcut/presentation/screens/product_list_screen.dart';
import 'package:nike_app/common/widgets/product_item.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  static const routeName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(create: (context) {
        var bloc = HomeBloc(locator<IBannerRepository>(), locator());
        bloc.add(HomeStarted());
        return bloc;
      }, child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.homeDataStatus is HomeDataLoading) {
            return Center(
                child: LoadingAnimationWidget.hexagonDots(
                    color: LightThemeColors.primaryColor, size: 40));
          }
          if (state.homeDataStatus is HomeDataResponse) {
            HomeDataResponse homeDataResponse =
                state.homeDataStatus as HomeDataResponse;
            var banners = homeDataResponse.banners;
            var latestProducts = homeDataResponse.latestProducts;
            var popularProducts = homeDataResponse.popularProducts;
            return ListView.builder(
                itemCount: 5,
                physics: Constants.defaultScrollPhysic,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Column(
                        children: [
                          Container(
                            height: 56,
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/nike_logo.png',
                              fit: BoxFit.fitHeight,
                              height: 24,
                            ),
                          ),
                          Container(
                            height: 56,
                            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                            child: TextField(
                              controller: searchController,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value) {
                                search(context);
                              },
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                  ),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                label: const Text('جستجو...'),
                                isCollapsed: false,
                                prefixIcon: IconButton(
                                    onPressed: () {
                                      search(context);
                                    },
                                    icon: const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon(CupertinoIcons.search),
                                    )),
                              ),
                            ),
                          )
                        ],
                      );
                    case 2:
                      return banners.fold((error) {
                        return Center(
                          child: Text(
                            error,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        );
                      }, (bannerList) {
                        return BannerSlider(bannerList: bannerList);
                      });
                    case 3:
                      return latestProducts.fold((error) {
                        return Center(
                          child: Text(error),
                        );
                      }, (latestProductList) {
                        return HorizontalProductList(
                          title: 'جدیدترین',
                          onTap: () {
                            Navigator.pushNamed(
                                context, ProductListScreen.routeName,
                                arguments: ProductListArgument(
                                    sort: ProductSort.latest));
                          },
                          productList: latestProductList,
                        );
                      });
                    case 4:
                      return popularProducts.fold((error) {
                        return Center(
                          child: Text(error),
                        );
                      }, (popularProductList) {
                        return HorizontalProductList(
                          title: 'پربازدیدترین',
                          onTap: () {
                            Navigator.pushNamed(
                                context, ProductListScreen.routeName,
                                arguments: ProductListArgument(
                                    sort: ProductSort.popular));
                          },
                          productList: popularProductList,
                        );
                      });
                    default:
                      return Container();
                  }
                });
          }
          return Container();
        },
      )),
    );
  }

  search(BuildContext context) {
    Navigator.pushNamed(context, ProductListScreen.routeName,
        arguments:
            ProductListArgument.search(searchTerm: searchController.text));
  }
}

class HorizontalProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<ProductModel> productList;
  const HorizontalProductList({
    super.key,
    required this.title,
    required this.onTap,
    required this.productList,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteManager = locator<FavoriteManger>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.subtitle1),
              TextButton(onPressed: onTap, child: const Text('مشاهده همه'))
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: ValueListenableBuilder<Box<ProductModel>>(
            valueListenable: favoriteManager.listenable,
            builder: (context, box, child) => ListView.builder(
                itemCount: productList.length,
                physics: Constants.defaultScrollPhysic,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  var product = productList[index];
                  var favoriteList = box.values.toList();
                  bool isFavorite = favoriteList.any(
                      (favoriteProduct) => favoriteProduct.id == product.id);
                  String heroTag = '${UniqueKey()}${product.id}';
                  return ProductItem(
                    product: product,
                    isFavorite: isFavorite,
                    heroTag: heroTag,
                    borderRadius: 12,
                  );
                }),
          ),
        )
      ],
    );
  }
}
