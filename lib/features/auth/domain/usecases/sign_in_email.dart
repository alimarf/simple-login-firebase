import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/auth_repo.dart';

class SignInEmail extends UsecaseWithParams<void, SignInEmailParams> {
  const SignInEmail(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture call(SignInEmailParams params) =>
      _repo.signInEmail(email: params.email);
}

class SignInEmailParams extends Equatable {
  const SignInEmailParams({
    required this.email,
  });

  final String email;

  @override
  List<String> get props => [email];
}
