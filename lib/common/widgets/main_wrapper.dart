import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:nike_app/common/utils/prefs_operator.dart';
import 'package:nike_app/common/widgets/badge.dart';
import 'package:nike_app/features/feature_cart/data/repository/cart_repository.dart';
import 'package:nike_app/features/feature_cart/presentation/screens/cart_screen.dart';
import 'package:nike_app/features/feature_home/presentation/screens/home_screen.dart';
import 'package:nike_app/features/feature_profile/presentation/screens/profile_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});
  static const routeName = '/main_wrapper';

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final int homeScreenIndex = 0;
  final int cartScreenIndex = 1;
  final int profileScreenIndex = 2;
  late int currentScreenIndex = homeScreenIndex;

  final GlobalKey<NavigatorState> homeScreenKey = GlobalKey();
  final GlobalKey<NavigatorState> cartScreenKey = GlobalKey();
  final GlobalKey<NavigatorState> profileScreenKey = GlobalKey();

  late final indexToKeyMap = {
    homeScreenIndex: homeScreenKey,
    cartScreenIndex: cartScreenKey,
    profileScreenIndex: profileScreenKey
  };

  final List<int> screenHistory = [];

  Future<bool> onWillPop() async {
    final NavigatorState currentNavigatorState =
        indexToKeyMap[currentScreenIndex]!.currentState!;
    if (currentNavigatorState.canPop()) {
      currentNavigatorState.pop();
      return false;
    } else if (screenHistory.isNotEmpty) {
      setState(() {
        currentScreenIndex = screenHistory.last;
        screenHistory.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  void initState() {
    PrefsOperator.loadUserData();

    if (PrefsOperator.authNotifier.value != null) {
      final ICartRepository cartRepository = locator();
      cartRepository.count();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: currentScreenIndex,
          children: [
            navigator(
                routeName: HomeScreen.routeName,
                screenIndex: homeScreenIndex,
                key: homeScreenKey,
                child: HomeScreen()),
            navigator(
                routeName: CartScreen.routeName,
                screenIndex: cartScreenIndex,
                key: cartScreenKey,
                child: const CartScreen()),
            navigator(
                routeName: ProfileScreen.routeName,
                screenIndex: profileScreenIndex,
                key: profileScreenKey,
                child: ProfileScreen())
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentScreenIndex,
            onTap: (selectedIndex) {
              setState(() {
                screenHistory.remove(currentScreenIndex);
                screenHistory.add(currentScreenIndex);
                currentScreenIndex = selectedIndex;
              });
            },
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), label: 'خانه'),
              BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(CupertinoIcons.cart),
                      Positioned(
                          right: -10,
                          child: ValueListenableBuilder<int>(
                              valueListenable:
                                  CartRepository.CartItemCountNotifier,
                              builder: (context, count, child) =>
                                  CartBadge(value: count))),
                    ],
                  ),
                  label: 'سبد خرید'),
              const BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person), label: 'پروفایل'),
            ]),
      ),
    );
  }

  Widget navigator(
          {required int screenIndex,
          required GlobalKey key,
          required Widget child,
          required String routeName}) =>
      key.currentState == null && screenIndex != currentScreenIndex
          ? Container()
          : Offstage(offstage: currentScreenIndex != screenIndex, child: child);
}
