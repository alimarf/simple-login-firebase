import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_login_firebase/features/auth/domain/usecases/send_email_verification.dart';
import 'package:simple_login_firebase/features/auth/domain/usecases/sign_in_email.dart';
import 'package:simple_login_firebase/features/auth/domain/usecases/sign_in_phone.dart';
import 'package:simple_login_firebase/features/auth/domain/usecases/sign_in_with_email_verification.dart';
import 'package:simple_login_firebase/features/auth/domain/usecases/sign_out.dart';
import 'package:simple_login_firebase/features/auth/domain/usecases/sign_up.dart';
import 'package:simple_login_firebase/features/auth/domain/usecases/verify_otp.dart';
import 'package:simple_login_firebase/features/auth/presentation/cubit/auth_cubit.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repo_impl.dart';
import '../../features/auth/domain/repositories/auth_repo.dart';

part 'injection_container.main.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initAuth();
}

Future<void> _initAuth() async {
  sl
    ..registerFactory(
      () => AuthCubit(
        signInPhone: sl(),
        verifyOtp: sl(),
        signUp: sl(),
        signOutUser: sl(),
        sendEmailVerification: sl(),
        signInEmail: sl(),
        signInWithEmailVerification: sl(),
      ),
    )
    ..registerLazySingleton(() => SignInPhone(sl()))
    ..registerLazySingleton(() => VerifyOtp(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => SignOutUser(sl()))
    ..registerLazySingleton(() => SendEmailVerification(sl()))
    ..registerLazySingleton(() => SignInEmail(sl()))
    ..registerLazySingleton(() => SignInWithEmailVerification(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}
