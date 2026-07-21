import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl(this.localDataSource);

  @override
  Future<Profile> getProfile() async {
    return await localDataSource.getProfile();
  }

  @override
  Future<void> signOut() async {
    await localDataSource.signOut();
  }
}