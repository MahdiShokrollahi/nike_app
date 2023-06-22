import 'package:equatable/equatable.dart';

abstract class AuthDataStatus extends Equatable {
  const AuthDataStatus();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthDataStatus {}

class AuthLoading extends AuthDataStatus {}

class AuthSuccess extends AuthDataStatus {}

class AuthError extends AuthDataStatus {
  final String error;

  const AuthError(this.error);

  @override
  List<Object> get props => [error];
}
