part of 'auth_bloc.dart';

class AuthState extends Equatable {
  bool isLoginMode;
  bool isObscureText;
  AuthDataStatus authDataStatus;
  AuthState({
    required this.isObscureText,
    required this.isLoginMode,
    required this.authDataStatus,
  });

  AuthState copyWith(
      {bool? newIsLoginMode,
      AuthDataStatus? newAuthDataStatus,
      bool? newObscureText}) {
    return AuthState(
        isObscureText: newObscureText ?? isObscureText,
        authDataStatus: newAuthDataStatus ?? authDataStatus,
        isLoginMode: newIsLoginMode ?? isLoginMode);
  }

  @override
  List<Object> get props => [isLoginMode, isObscureText, authDataStatus];
}
