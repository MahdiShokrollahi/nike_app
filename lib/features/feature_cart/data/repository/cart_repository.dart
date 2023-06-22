import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:nike_app/common/error_handling/app_exceptions.dart';
import 'package:nike_app/common/error_handling/check_exceptions.dart';
import 'package:nike_app/features/feature_cart/data/data_source/cart_data_source.dart';
import 'package:nike_app/features/feature_cart/data/model/add_to_cart.dart';

abstract class ICartRepository {
  Future<dynamic> add(int productId);
  Future<dynamic> changeCount(int cartItemId, int count);
  Future<dynamic> count();
  Future<void> delete(int cartItemId);
  Future<dynamic> getAll();
}

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;
  static ValueNotifier<int> CartItemCountNotifier = ValueNotifier(0);

  CartRepository(this.dataSource);
  @override
  Future<dynamic> add(int productId) async {
    try {
      var response = await dataSource.add(productId);
      return right(response);
    } on AppException catch (e) {
      return CheckException.getError(e);
    }
  }

  @override
  Future<AddToCartModel> changeCount(int cartItemId, int count) async =>
      await dataSource.changeCount(cartItemId, count);

  @override
  Future<int> count() async {
    int cartCount = await dataSource.count();
    CartItemCountNotifier.value = cartCount;
    return cartCount;
  }

  @override
  Future<void> delete(int cartItemId) async =>
      await dataSource.delete(cartItemId);

  @override
  Future<dynamic> getAll() async {
    try {
      var response = await dataSource.getAll();
      return right(response);
    } on AppException catch (e) {
      return CheckException.getError(e);
    }
  }
}
