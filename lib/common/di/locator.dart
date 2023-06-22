import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nike_app/common/utils/constants.dart';
import 'package:nike_app/common/utils/favorite_manager.dart';
import 'package:nike_app/common/utils/prefs_operator.dart';
import 'package:nike_app/features/feature_auth/data/data_source/auth_data_source.dart';
import 'package:nike_app/features/feature_auth/data/repository/auth_repository.dart';
import 'package:nike_app/features/feature_cart/data/data_source/cart_data_source.dart';
import 'package:nike_app/features/feature_cart/data/repository/cart_repository.dart';
import 'package:nike_app/features/feature_home/data/data_source/banner_data_source.dart';
import 'package:nike_app/features/feature_prodcut/data/data_source/product_data_source.dart';
import 'package:nike_app/features/feature_home/data/repository/banner_repository.dart';
import 'package:nike_app/features/feature_prodcut/data/repository/prodcut_repository.dart';
import 'package:nike_app/features/feature_order/data/data_source/order_data_status.dart';
import 'package:nike_app/features/feature_order/data/repository/order_repository.dart';
import 'package:nike_app/features/feature_prodcut/data/data_source/comment_data_source.dart';
import 'package:nike_app/features/feature_prodcut/data/repository/comment_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

var locator = GetIt.instance;

Future<void> getItInit() async {
  locator.registerSingleton<Dio>(Dio(BaseOptions(baseUrl: Constants.baseUrl))
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final authInfo = PrefsOperator.authNotifier.value;
        if (authInfo != null && authInfo.accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ${authInfo.accessToken}';
        }
        handler.next(options);
      },
    )));

  locator.registerFactory<FavoriteManger>(() => FavoriteManger());

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(sharedPreferences);

  //data sources
  locator.registerFactory<IBannerDataSource>(
      () => BannerRemoteDataSource(locator()));
  locator.registerFactory<IProductDataSource>(
      () => ProductRemoteDataSource(locator()));
  locator.registerFactory<ICommentDataSource>(
      () => CommentRemoteDataSource(locator()));
  locator
      .registerFactory<ICartDataSource>(() => CartRemoteDataSource(locator()));
  locator
      .registerFactory<IAuthDataSource>(() => AuthRemoteDataSource(locator()));
  locator.registerFactory<IOrderDataSource>(
      () => OrderRemoteDataSource(locator()));

  // repository
  locator.registerFactory<IBannerRepository>(() => BannerRepository(locator()));
  locator
      .registerFactory<IProductRepository>(() => ProductRepository(locator()));
  locator
      .registerFactory<ICommentRepository>(() => CommentRepository(locator()));
  locator.registerFactory<ICartRepository>(() => CartRepository(locator()));
  locator.registerFactory<IAuthRepository>(() => AuthRepository(locator()));
  locator.registerFactory<IOrderRepository>(() => OrderRepository(locator()));
}
