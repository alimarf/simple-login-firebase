// ignore_for_file: constant_identifier_names

part of 'routes.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const PIN = _Paths.PIN;
  static const PROFILE = _Paths.PROFILE;
  static const VERIFY_EMAIL = _Paths.VERIFY_EMAIL;
}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const PIN = '/pin';
  static const PROFILE = '/profile';
  static const VERIFY_EMAIL = '/verify-otp';
}
