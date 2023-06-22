import 'package:dio/dio.dart';
import 'package:nike_app/common/error_handling/check_exceptions.dart';
import 'package:nike_app/common/utils/constants.dart';
import 'package:nike_app/features/feature_auth/data/model/auth_info.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> signUP(String userName, String password);
  Future<AuthInfo> login(String userName, String password);
  Future<AuthInfo> refreshToken(String token);
}

class AuthRemoteDataSource extends IAuthDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);
  @override
  Future<AuthInfo> login(String userName, String password) async {
    try {
      var response = await dio.post('auth/token', data: {
        "grant_type": "password",
        "client_id": 2,
        "client_secret": Constants.clientSecret,
        "username": userName,
        "password": password
      });
      var authInfo = AuthInfo(response.data['access_token'],
          response.data['refresh_token'], userName);
      return authInfo;
    } on DioError catch (e) {
      return CheckException.response(e.response!);
    }
  }

  @override
  Future<AuthInfo> refreshToken(String token) async {
    try {
      final response = await dio.post("auth/token", data: {
        "grant_type": "refresh_token",
        "refresh_token": token,
        "client_id": 2,
        "client_secret": Constants.clientSecret
      });
      var authInfo = AuthInfo(
          response.data["access_token"], response.data["refresh_token"], '');
      return authInfo;
    } on DioError catch (e) {
      return CheckException.response(e.response!);
    }
  }

  @override
  Future<AuthInfo> signUP(String userName, String password) async {
    try {
      final response = await dio.post("user/register",
          data: {"email": userName, "password": password});

      return login(userName, password);
    } on DioError catch (e) {
      return CheckException.response(e.response!);
    }
  }
}
