import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:nike_app/common/utils/constants.dart';
import 'package:nike_app/common/utils/theme_color.dart';
import 'package:nike_app/common/widgets/main_wrapper.dart';
import 'package:nike_app/features/feature_auth/presentation/screens/auth_screen.dart';
import 'package:nike_app/features/feature_home/presentation/screens/home_screen.dart';
import 'package:nike_app/features/feature_order/presentation/blocs/order_history_bloc/order_history_bloc.dart';
import 'package:nike_app/features/feature_order/presentation/screens/order_history_screen.dart';
import 'package:nike_app/features/feature_order/presentation/screens/payment_gateway_screen.dart';
import 'package:nike_app/features/feature_order/presentation/screens/payment_receipt_screen.dart';
import 'package:nike_app/features/feature_order/presentation/screens/shipping_screen.dart';
import 'package:nike_app/features/feature_prodcut/data/model/product.dart';
import 'package:nike_app/features/feature_prodcut/presentation/screens/prodcut_detail_screen.dart';
import 'package:nike_app/features/feature_prodcut/presentation/screens/product_list_screen.dart';
import 'package:nike_app/features/feature_profile/presentation/screens/favorite_screen.dart';
import 'package:nike_app/features/feature_profile/presentation/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getItInit();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());
  await Hive.openBox<ProductModel>('ProductBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
        AuthScreen.routeName: (context) => AuthScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        PaymentReceiptScreen.routeName: (context) =>
            const PaymentReceiptScreen(),
        PaymentGatewayScreen.routeName: (context) => PaymentGatewayScreen(),
        ShippingScreen.routeName: (context) => ShippingScreen(),
        ProductListScreen.routeName: (context) => ProductListScreen(),
        FavoriteScreen.routeName: (context) => FavoriteScreen(),
        OrderHistoryScreen.routeName: (context) => const OrderHistoryScreen()
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        hintColor: LightThemeColors.secondaryTextColor,
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: LightThemeColors.primaryTextColor.withOpacity(0.1),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: LightThemeColors.primaryTextColor),
        snackBarTheme: SnackBarThemeData(
            contentTextStyle:
                Constants.defaultTextStyle.apply(color: Colors.white)),
        textTheme: TextTheme(
            titleMedium: Constants.defaultTextStyle
                .apply(color: LightThemeColors.secondaryTextColor),
            bodyMedium: Constants.defaultTextStyle,
            labelLarge: Constants.defaultTextStyle,
            bodySmall: Constants.defaultTextStyle
                .apply(color: LightThemeColors.secondaryTextColor),
            titleLarge: Constants.defaultTextStyle
                .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
        colorScheme: const ColorScheme.light(
            primary: LightThemeColors.primaryColor,
            secondary: LightThemeColors.secondaryColor,
            onSecondary: Colors.white,
            surfaceVariant: Color(0xffF5F5F5)),
      ),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: MainWrapper()),
    );
  }
}
