import 'package:dartz/dartz.dart';
import 'package:nike_app/common/error_handling/app_exceptions.dart';
import 'package:nike_app/common/error_handling/check_exceptions.dart';
import 'package:nike_app/common/utils/prefs_operator.dart';
import 'package:nike_app/features/feature_auth/data/data_source/auth_data_source.dart';
import 'package:nike_app/features/feature_auth/data/model/auth_info.dart';

abstract class IAuthRepository {
  Future<dynamic> login(String userName, String password);
  Future<dynamic> signUp(String userName, String password);
  Future<dynamic> refreshToken();
  Future<void> logout();
}

class AuthRepository extends IAuthRepository {
  final IAuthDataSource dataSource;

  AuthRepository(this.dataSource);
  @override
  Future<dynamic> login(String userName, String password) async {
    try {
      final AuthInfo authInfo = await dataSource.login(userName, password);
      PrefsOperator.persistAuthTokens(authInfo);
      return right(authInfo);
    } on AppException catch (e) {
      return CheckException.getError(e);
    }
  }

  @override
  Future<Either<String, AuthInfo>> refreshToken() async {
    try {
      if (PrefsOperator.authNotifier.value != null) {
        final AuthInfo authInfo = await dataSource
            .refreshToken(PrefsOperator.authNotifier.value!.refreshToken);
        PrefsOperator.persistAuthTokens(authInfo);
        return right(authInfo);
      } else {
        return left('please log in again');
      }
    } on AppException catch (e) {
      return CheckException.getError(e);
    }
  }

  @override
  Future<void> logout() async {
    PrefsOperator.logOut();
  }

  @override
  Future<Either<String, AuthInfo>> signUp(
      String userName, String password) async {
    try {
      final AuthInfo authInfo = await dataSource.signUP(userName, password);
      PrefsOperator.persistAuthTokens(authInfo);
      return right(authInfo);
    } on AppException catch (e) {
      return CheckException.getError(e);
    }
  }
}
