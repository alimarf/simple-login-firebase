part of 'routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: const SplashPage(),
      ),
    ),

    //AUTH
    GetPage(
      name: _Paths.LOGIN,
      page: () => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const LoginPage(),
      ),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: const RegisterPage(),
      ),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: const ProfilePage(),
      ),
    ),
    GetPage(
      name: _Paths.PIN,
      page: () => BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: const PinPage(),
      ),
    ),
    GetPage(
      name: _Paths.VERIFY_EMAIL,
      page: () => BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: const VerifyEmailPage(),
      ),
    ),
  ];
}
