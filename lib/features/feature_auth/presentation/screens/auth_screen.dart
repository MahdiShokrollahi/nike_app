import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_app/common/di/locator.dart';
import 'package:nike_app/common/utils/custom_snackbar.dart';
import 'package:nike_app/common/utils/theme_color.dart';
import 'package:nike_app/features/feature_auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:nike_app/features/feature_auth/presentation/blocs/auth_bloc/auth_data_status.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});
  static const routeName = '/auth_screen';
  final TextEditingController userNameController =
      TextEditingController(text: 'mahdi123@gmail.com');
  final TextEditingController passwordController =
      TextEditingController(text: '137881sh');
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Theme(
      data: themeData.copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  const Size.fromHeight(56),
                ),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
                backgroundColor:
                    MaterialStateProperty.all(LightThemeColors.onBackground),
                foregroundColor:
                    MaterialStateProperty.all(themeData.colorScheme.secondary)),
          ),
          snackBarTheme: SnackBarThemeData(
              backgroundColor: themeData.colorScheme.primary,
              contentTextStyle: const TextStyle(fontFamily: 'IranYekan')),
          colorScheme: themeData.colorScheme
              .copyWith(onSurface: LightThemeColors.onBackground),
          inputDecorationTheme: InputDecorationTheme(
              labelStyle: const TextStyle(
                color: LightThemeColors.onBackground,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.white, width: 1)))),
      child: Scaffold(
        backgroundColor: themeData.colorScheme.secondary,
        body: BlocProvider(
          create: (context) => AuthBloc(locator(), locator()),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.authDataStatus is AuthSuccess) {
                Navigator.pop(context);
              }
              if (state.authDataStatus is AuthError) {
                AuthError authError = state.authDataStatus as AuthError;

                CustomSnackbar.showSnackbar(context, message: authError.error);
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/nike_logo.png',
                      color: Colors.white,
                      width: 120,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      state.isLoginMode ? 'خوش آمدید' : 'ثبت نام',
                      style: const TextStyle(
                          color: LightThemeColors.onBackground, fontSize: 22),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      state.isLoginMode
                          ? 'لطفا وارد حساب کاربری خود شوید'
                          : 'ایمیل و رمز عبور خود را تعیین کنید',
                      style: const TextStyle(
                          color: LightThemeColors.onBackground, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextField(
                      controller: userNameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        label: Text('آدرس ایمیل'),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.number,
                      obscureText: state.isObscureText,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(ObscureChangeEvent());
                            },
                            icon: Icon(state.isObscureText
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined)),
                        label: const Text('رمز عبور'),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(
                            AuthButtonIsClicked(userNameController.text,
                                passwordController.text));
                      },
                      child: (state.authDataStatus is AuthLoading)
                          ? const CircularProgressIndicator()
                          : Text(state.isLoginMode ? 'ورود' : 'ثبت نام'),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<AuthBloc>(context)
                            .add(ChangeLoginModeEvent());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.isLoginMode
                                ? 'حساب کاربری ندارید؟'
                                : 'حساب کاربری دارید؟',
                            style: TextStyle(
                                color: LightThemeColors.onBackground
                                    .withOpacity(0.7)),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            state.isLoginMode ? 'ثبت نام' : 'ورود',
                            style: TextStyle(
                                color: themeData.colorScheme.primary,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
