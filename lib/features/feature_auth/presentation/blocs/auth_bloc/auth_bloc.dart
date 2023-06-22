import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_app/features/feature_auth/data/repository/auth_repository.dart';
import 'package:nike_app/features/feature_auth/presentation/blocs/auth_bloc/auth_data_status.dart';
import 'package:nike_app/features/feature_cart/data/repository/cart_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;
  final ICartRepository cartRepository;
  AuthBloc(this.authRepository, this.cartRepository)
      : super(AuthState(
            isObscureText: true,
            isLoginMode: true,
            authDataStatus: AuthInitial())) {
    on<AuthButtonIsClicked>((event, emit) async {
      emit(state.copyWith(newAuthDataStatus: AuthLoading()));
      if (state.isLoginMode) {
        var login = await authRepository.login(event.userName, event.password);
        await cartRepository.count();
        login.fold((error) {
          emit(state.copyWith(newAuthDataStatus: AuthError(error)));
        }, (authInfo) {
          emit(state.copyWith(newAuthDataStatus: AuthSuccess()));
        });
      } else {
        var signUp =
            await authRepository.signUp(event.userName, event.password);
        signUp.fold((error) {
          emit(state.copyWith(newAuthDataStatus: AuthError(error)));
        }, (authInfo) {
          emit(state.copyWith(newAuthDataStatus: AuthSuccess()));
        });
      }
    });

    on<ChangeLoginModeEvent>((event, emit) {
      if (state.isLoginMode) {
        emit(state.copyWith(newIsLoginMode: false));
      } else {
        emit(state.copyWith(newIsLoginMode: true));
      }
    });

    on<ObscureChangeEvent>((event, emit) {
      if (state.isObscureText) {
        emit(state.copyWith(newObscureText: false));
      } else {
        emit(state.copyWith(newObscureText: true));
      }
    });
  }
}
