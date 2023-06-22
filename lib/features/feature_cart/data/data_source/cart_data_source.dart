import 'package:dio/dio.dart';
import 'package:nike_app/common/error_handling/check_exceptions.dart';
import 'package:nike_app/features/feature_cart/data/model/add_to_cart.dart';
import 'package:nike_app/features/feature_cart/data/model/cart_response.dart';

abstract class ICartDataSource {
  Future<AddToCartModel> add(int productId);
  Future<AddToCartModel> changeCount(int cartItemId, int count);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
}

class CartRemoteDataSource implements ICartDataSource {
  final Dio dio;

  CartRemoteDataSource(this.dio);
  @override
  Future<AddToCartModel> add(int productId) async {
    try {
      var response =
          await dio.post('cart/add', data: {'product_id': productId});
      final cartModel = AddToCartModel.fromJson(response.data);
      return cartModel;
    } on DioError catch (e) {
      return CheckException.response(e.response!);
    }
  }

  @override
  Future<AddToCartModel> changeCount(int cartItemId, int count) async {
    var response = await dio.post('cart/changeCount', data: {
      "cart_item_id": cartItemId,
      "count": count,
    });
    final addTOCartModel = AddToCartModel.fromJson(response.data);
    return addTOCartModel;
  }

  @override
  Future<int> count() async {
    final response = await dio.get('cart/count');
    return response.data['count'];
  }

  @override
  Future<void> delete(int cartItemId) async {
    await dio.post('cart/remove', data: {'cart_item_id': cartItemId});
  }

  @override
  Future<CartResponse> getAll() async {
    try {
      final response = await dio.get('cart/list');
      final cartResponse = CartResponse.fromJson(response.data);
      return cartResponse;
    } on DioError catch (e) {
      return CheckException.response(e.response!);
    }
  }
}
