import '../repositories/auth_repo.dart';

class SignOutUser {
  final AuthRepo _repo;

  const SignOutUser(this._repo);

  Future<void> call() async => _repo.signOut();
}
