import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/auth_repo.dart';

class SignInWithEmailVerification
    extends UsecaseWithParams<void, SignInEmailVerificationParams> {
  const SignInWithEmailVerification(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture call(SignInEmailVerificationParams params) =>
      _repo.signInWithEmailVerification(email: params.email);
}

class SignInEmailVerificationParams extends Equatable {
  const SignInEmailVerificationParams({
    required this.email,
  });

  final String email;

  @override
  List<String> get props => [email];
}
