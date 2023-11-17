import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/auth_repo.dart';

class VerifyOtp extends UsecaseWithParams<void, VerifyOtpParams> {
  const VerifyOtp(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture call(VerifyOtpParams params) => _repo.verifyOtpCode(
        otpCode: params.otpCode,
        verificationId: params.verificationId,
      );
}

class VerifyOtpParams extends Equatable {
  final String otpCode;
  final String verificationId;

  const VerifyOtpParams({
    required this.otpCode,
    required this.verificationId,
  });

  @override
  List<String> get props => [otpCode, verificationId];
}
