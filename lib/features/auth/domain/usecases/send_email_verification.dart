import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/auth_repo.dart';

class SendEmailVerification extends UsecaseWithoutParams {
  SendEmailVerification(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture call() => _repo.sendEmailVerification();
}
