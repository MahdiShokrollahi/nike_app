part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthButtonIsClicked extends AuthEvent {
  final String userName;
  final String password;

  const AuthButtonIsClicked(this.userName, this.password);
}

class ChangeLoginModeEvent extends AuthEvent {}

class ObscureChangeEvent extends AuthEvent {}
