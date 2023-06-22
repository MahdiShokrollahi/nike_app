// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nike_app/features/feature_auth/data/model/auth_info.dart';

class PrefsOperator {
  static final SharedPreferences sharedPreferences = locator();
  static final ValueNotifier<AuthInfo?> authNotifier = ValueNotifier(null);

  static persistAuthTokens(AuthInfo authInfo) {
    sharedPreferences.setString('access_token', authInfo.accessToken);
    sharedPreferences.setString('refresh_token', authInfo.refreshToken);
    sharedPreferences.setString('user_name', authInfo.userName);
    loadUserData();
  }

  static loadUserData() {
    var accessToken = sharedPreferences.getString('access_token') ?? '';
    var refreshToken = sharedPreferences.getString('refresh_token') ?? '';
    var userName = sharedPreferences.getString('user_name') ?? '';
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authNotifier.value = AuthInfo(accessToken, refreshToken, userName);
    }
  }

  static bool inUserLoggedIn() {
    return authNotifier.value != null &&
        authNotifier.value!.accessToken != null &&
        authNotifier.value!.refreshToken.isNotEmpty;
  }

  static logOut() {
    sharedPreferences.clear();
    authNotifier.value = null;
  }
}
