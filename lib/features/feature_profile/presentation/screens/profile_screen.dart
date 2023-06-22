import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:nike_app/common/utils/prefs_operator.dart';
import 'package:nike_app/features/feature_auth/data/repository/auth_repository.dart';
import 'package:nike_app/features/feature_auth/presentation/screens/auth_screen.dart';
import 'package:nike_app/features/feature_cart/data/repository/cart_repository.dart';
import 'package:nike_app/features/feature_order/presentation/screens/order_history_screen.dart';
import 'package:nike_app/features/feature_profile/presentation/screens/favorite_screen.dart';
import 'package:nike_app/features/feature_profile/presentation/widgets/profile_list_title.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('پروفایل'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: PrefsOperator.authNotifier,
        builder: (context, authInfo, child) {
          var isLogin = authInfo != null && authInfo.accessToken.isNotEmpty;
          List<ProfileListTitle> profileList = [
            ProfileListTitle(
                title: 'لیست علاقه مندی ها',
                icon: Icon(CupertinoIcons.heart),
                onTap: () {
                  Navigator.pushNamed(context, FavoriteScreen.routeName);
                }),
            ProfileListTitle(
                title: 'سوابق سفارش',
                icon: Icon(CupertinoIcons.cart),
                onTap: () {
                  Navigator.pushNamed(context, OrderHistoryScreen.routeName);
                }),
            ProfileListTitle(
                title: isLogin ? 'خروج از حساب کاربری' : 'ورود به حساب کاربری',
                icon: Icon(
                  isLogin
                      ? CupertinoIcons.arrow_right_square
                      : CupertinoIcons.arrow_left_square,
                ),
                onTap: () {
                  if (isLogin) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              title: const Text('خروج از حساب کاربری'),
                              content: const Text(
                                'آیا می خواهید از حساب کاربری خود خارج شوید؟',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('خیر'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final IAuthRepository authRepository =
                                        locator();
                                    CartRepository.CartItemCountNotifier.value =
                                        0;
                                    authRepository.logout();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('بله'),
                                ),
                              ],
                            ),
                          );
                        });
                  } else {
                    Navigator.pushNamed(context, AuthScreen.routeName);
                  }
                })
          ];
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(top: 32, bottom: 15),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey)),
                  child: Image.asset('assets/images/nike_logo.png'),
                ),
                Text(isLogin ? authInfo.userName : 'کاربر میهمان'),
                const SizedBox(
                  height: 32,
                ),
                const Divider(
                  height: 1,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: profileList.length,
                      itemBuilder: (context, index) {
                        return ProfileListTitle(
                            title: profileList[index].title,
                            icon: profileList[index].icon,
                            onTap: profileList[index].onTap);
                      }),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
