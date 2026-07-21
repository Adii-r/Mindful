import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/profile_local_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';

final profileLocalDataSourceProvider =
Provider<ProfileLocalDataSource>((ref) {
  return ProfileLocalDataSource();
});

final profileRepositoryProvider =
Provider<ProfileRepositoryImpl>((ref) {
  return ProfileRepositoryImpl(
    ref.read(profileLocalDataSourceProvider),
  );
});

final getProfileUseCaseProvider =
Provider<GetProfileUseCase>((ref) {
  return GetProfileUseCase(
    ref.read(profileRepositoryProvider),
  );
});

final signOutUseCaseProvider =
Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(
    ref.read(profileRepositoryProvider),
  );
});

final profileProvider = Provider<ProfileService>((ref) {
  return ProfileService(
    getProfileUseCase: ref.read(getProfileUseCaseProvider),
    signOutUseCase: ref.read(signOutUseCaseProvider),
  );
});

class ProfileService {
  final GetProfileUseCase getProfileUseCase;
  final SignOutUseCase signOutUseCase;

  ProfileService({
    required this.getProfileUseCase,
    required this.signOutUseCase,
  });

  Future getProfile() async {
    return await getProfileUseCase();
  }

  Future<void> signOut() async {
    await signOutUseCase();
  }
}