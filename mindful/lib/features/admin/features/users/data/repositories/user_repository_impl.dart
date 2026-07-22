import '../../domain/repositories/user_repository.dart';

import '../datasources/user_remote_datasource.dart';

import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;

  UserRepositoryImpl(this.remote);

  @override
  Future<List<UserModel>> getUsers() async {
    return await remote.getUsers();
  }

  @override
  Future<void> updateRole(String id, String role) async {
    await remote.updateRole(id, role);
  }

  @override
  Future<void> deleteUser(String id) async {
    await remote.deleteUser(id);
  }
}
