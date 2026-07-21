import '../repositories/profile_repository.dart';

class SignOutUseCase {
  final ProfileRepository repository;

  SignOutUseCase(this.repository);

  Future<void> call() async {
    await repository.signOut();
  }
}