import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nike_app/common/arguments/price_argument.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:nike_app/common/utils/prefs_operator.dart';
import 'package:nike_app/common/utils/theme_color.dart';
import 'package:nike_app/features/feature_auth/presentation/screens/auth_screen.dart';
import 'package:nike_app/features/feature_cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:nike_app/features/feature_cart/presentation/blocs/cart_bloc/cart_data_status.dart';
import 'package:nike_app/features/feature_cart/presentation/widgets/cart_item.dart';
import 'package:nike_app/features/feature_cart/presentation/widgets/custom_view.dart';
import 'package:nike_app/features/feature_cart/presentation/widgets/price_info.dart';
import 'package:nike_app/features/feature_order/presentation/screens/shipping_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static const routeName = '/cart_screen';
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StreamSubscription? streamSubscription;
  final RefreshController refreshController = RefreshController();
  CartBloc? cartBloc;
  @override
  void initState() {
    PrefsOperator.authNotifier.addListener(authChangeNotifierListener);
    super.initState();
  }

  void authChangeNotifierListener() {
    cartBloc?.add(CartAuthInfoChanged(PrefsOperator.authNotifier.value));
  }

  @override
  void dispose() {
    PrefsOperator.authNotifier.removeListener(authChangeNotifierListener);
    cartBloc?.close();
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return BlocProvider(
      create: (context) {
        var bloc = CartBloc(locator());
        streamSubscription = bloc.stream.listen((state) {
          if (refreshController.isRefresh) {
            if (state.cartDataStatus is CartDataSuccess) {
              refreshController.refreshCompleted();
            }
            if (state.cartDataStatus is CartDataError) {
              refreshController.refreshFailed();
            }
          }
        });
        cartBloc = bloc;
        bloc.add(CartStarted(PrefsOperator.authNotifier.value));
        return bloc;
      },
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Visibility(
                visible: state.cartDataStatus is CartDataSuccess ? true : false,
                child: FadeInUp(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 48),
                    width: MediaQuery.of(context).size.width,
                    child: FloatingActionButton.extended(
                        onPressed: () {
                          if (state.cartDataStatus is CartDataSuccess) {
                            CartDataSuccess cartDataSuccess =
                                state.cartDataStatus as CartDataSuccess;
                            var payablePrice =
                                cartDataSuccess.cartResponse.payablePrice;
                            var shippingCost =
                                cartDataSuccess.cartResponse.shippingCost;
                            var totalPrice =
                                cartDataSuccess.cartResponse.totalPrice;
                            Navigator.pushNamed(
                                context, ShippingScreen.routeName,
                                arguments: PriceArgument(
                                    totalPrice, shippingCost, payablePrice));
                          }
                        },
                        label: const Text('پرداخت')),
                  ),
                ),
              );
            },
          ),
          backgroundColor: themeData.colorScheme.surfaceVariant,
          appBar: AppBar(
            title: const Text('سبد خرید'),
            centerTitle: true,
          ),
          body: Scaffold(
            body: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
              if (state.cartDataStatus is CartDataLoading) {
                return Center(
                    child: LoadingAnimationWidget.hexagonDots(
                        color: LightThemeColors.primaryColor, size: 40));
              }
              if (state.cartDataStatus is CartDataSuccess) {
                CartDataSuccess cartDataSuccess =
                    state.cartDataStatus as CartDataSuccess;
                var cartItems = cartDataSuccess.cartResponse.cartItems;
                var payablePrice = cartDataSuccess.cartResponse.payablePrice;
                var shippingCost = cartDataSuccess.cartResponse.shippingCost;
                var totalPrice = cartDataSuccess.cartResponse.totalPrice;
                return SmartRefresher(
                  controller: refreshController,
                  header: const ClassicHeader(
                    completeText: 'با موفقیت انجام شد',
                    refreshingText: 'در حال بروزرسانی',
                    idleText: 'برای بروزرسانی پایین بکشید',
                    releaseText: 'رها کنید',
                    spacing: 2,
                    completeIcon: Icon(CupertinoIcons.checkmark_circle),
                  ),
                  onRefresh: () {
                    BlocProvider.of<CartBloc>(context).add(CartStarted(
                        PrefsOperator.authNotifier.value,
                        isRefreshing: true));
                  },
                  child: ListView.builder(
                      itemCount: cartItems.length + 1,
                      padding: const EdgeInsets.only(bottom: 80),
                      itemBuilder: (context, index) {
                        if (index < cartItems.length) {
                          return CartItem(
                            cartItem: cartItems[index],
                          );
                        } else {
                          return FadeInUp(
                            child: PriceInfo(
                                payablePrice: payablePrice,
                                shippingCost: shippingCost,
                                totalPrice: totalPrice),
                          );
                        }
                      }),
                );
              }

              if (state.cartDataStatus is CartEmpty) {
                return Center(
                    child: CustomView(
                        message:
                            'تاکنون هیچ محصولی به سبد خرید خود اضافه نکرده اید',
                        image: SvgPicture.asset(
                          'assets/images/empty_cart.svg',
                          width: 200,
                        )));
              }
              if (state.cartDataStatus is CartDataError) {
                CartDataError cartDataError =
                    state.cartDataStatus as CartDataError;

                return Center(
                  child: Text(cartDataError.error),
                );
              }
              if (state.cartDataStatus is CartAuthRequired) {
                return CustomView(
                    message:
                        'برای مشاهده ی سبد خرید ابتدا وارد حساب کاربری خود شوید',
                    callTOAction: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AuthScreen.routeName);
                        },
                        child: const Text('ورود به حساب کاربری')),
                    image: SvgPicture.asset(
                      'assets/images/auth_required.svg',
                      width: 140,
                    ));
              }
              return const Center(
                child: Text('state is not valid'),
              );
            }),
          )),
    );
  }
}
