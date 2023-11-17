import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/auth_repo.dart';

class SignInPhone extends UsecaseWithParams<void, SignInPhoneParams> {
  const SignInPhone(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture call(SignInPhoneParams params) =>
      _repo.signInPhone(phoneNumber: params.phoneNumber);
}

class SignInPhoneParams extends Equatable {
  const SignInPhoneParams({
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  List<String> get props => [phoneNumber];
}
