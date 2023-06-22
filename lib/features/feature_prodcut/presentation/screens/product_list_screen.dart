import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nike_app/common/arguments/product_list_argument.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:nike_app/common/enums/view_type.dart';
import 'package:nike_app/common/utils/favorite_manager.dart';
import 'package:nike_app/common/utils/theme_color.dart';
import 'package:nike_app/features/feature_prodcut/presentation/blocs/product_list_bloc/product_list_bloc.dart';
import 'package:nike_app/features/feature_prodcut/presentation/blocs/product_list_bloc/product_list_data_status.dart';
import 'package:nike_app/common/widgets/product_item.dart';

class ProductListScreen extends StatefulWidget {
  ProductListScreen({super.key});
  static const routeName = '/product_list_screen';

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  ViewType viewType = ViewType.grid;
  ProductListBloc? productBloc;
  @override
  void dispose() {
    productBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final favoriteManager = locator<FavoriteManger>();
    final productListArgument =
        ModalRoute.of(context)!.settings.arguments as ProductListArgument;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: productListArgument.searchTerm.isEmpty
              ? Text('کفش های ورزشی')
              : Text('${productListArgument.searchTerm} :نتایج جستجو'),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocProvider(
          create: (context) {
            final bloc = ProductListBloc(locator());
            productBloc = bloc;
            bloc.add(ProductListStarted(
                productListArgument.sort, productListArgument.searchTerm));
            return bloc;
          },
          child: BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              if (state.productListDataStatus is ProductListDataLoading) {
                return Center(
                    child: LoadingAnimationWidget.hexagonDots(
                        color: LightThemeColors.primaryColor, size: 45));
              }
              if (state.productListDataStatus is ProductListDataSuccess) {
                ProductListDataSuccess productListDataSuccess =
                    state.productListDataStatus as ProductListDataSuccess;
                var sortNameList = productListDataSuccess.sortName;
                var sortId = productListDataSuccess.sort;
                var productList = productListDataSuccess.productList;
                return Column(
                  children: [
                    if (productListArgument.searchTerm.isEmpty)
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                              width: 1,
                              color: themeData.dividerColor,
                            )),
                            color: themeData.colorScheme.surface,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20)
                            ]),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(32))),
                                builder: (context) {
                                  return SizedBox(
                                      height: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 24),
                                        child: Column(
                                          children: [
                                            Text(
                                              'انتخاب مرتب سازی',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6,
                                            ),
                                            Expanded(
                                                child: ListView.builder(
                                                    itemCount:
                                                        sortNameList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          productBloc!.add(
                                                              ProductListStarted(
                                                                  index,
                                                                  productListArgument
                                                                      .searchTerm));
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 8),
                                                          child: SizedBox(
                                                            height: 32,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                if (index ==
                                                                    sortId)
                                                                  Icon(
                                                                      CupertinoIcons
                                                                          .check_mark_circled_solid,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(
                                                                    sortNameList[
                                                                        index]),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }))
                                          ],
                                        ),
                                      ));
                                });
                          },
                          child: Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon:
                                          const Icon(CupertinoIcons.sort_down),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('مرتب سازی'),
                                        Text(
                                          sortNameList[sortId],
                                          style: themeData.textTheme.bodySmall,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                              Container(
                                width: 1,
                                color: themeData.dividerColor,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        viewType == ViewType.grid
                                            ? viewType = ViewType.list
                                            : viewType = ViewType.grid;
                                      });
                                    },
                                    icon: const Icon(
                                        CupertinoIcons.square_grid_2x2)),
                              )
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: favoriteManager.listenable,
                        builder: (context, box, child) => GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.65,
                                  crossAxisCount:
                                      viewType == ViewType.grid ? 2 : 1),
                          itemBuilder: (context, index) {
                            var product = productList[index];
                            var favoriteList = box.values.toList();
                            bool isFavorite = favoriteList.any(
                                (favoriteProduct) =>
                                    favoriteProduct.id == product.id);
                            String heroTag = '${UniqueKey()}${product.id}';
                            return ProductItem(
                              isFavorite: isFavorite,
                              product: productList[index],
                              borderRadius: 0,
                              heroTag: heroTag,
                            );
                          },
                          itemCount: productList.length,
                        ),
                      ),
                    )
                  ],
                );
              }
              if (state.productListDataStatus is ProductListDataError) {
                ProductListDataError productListDataError =
                    state.productListDataStatus as ProductListDataError;
                return Center(
                  child: Text(productListDataError.error),
                );
              }
              return const Center(
                child: Text('state is not valid'),
              );
            },
          ),
        ),
      ),
    );
  }
}
