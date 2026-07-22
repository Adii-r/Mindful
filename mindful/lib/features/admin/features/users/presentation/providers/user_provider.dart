import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/user_remote_datasource.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository_impl.dart';

final userRepositoryProvider = Provider((ref) {
  return UserRepositoryImpl(UserRemoteDataSource());
});

final userProvider = StateNotifierProvider<UserNotifier, List<UserModel>>((
  ref,
) {
  return UserNotifier(ref.read(userRepositoryProvider));
});

class UserNotifier extends StateNotifier<List<UserModel>> {
  final UserRepositoryImpl repository;

  UserNotifier(this.repository) : super([]) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    state = await repository.getUsers();
  }

  Future<void> changeRole(String id, String role) async {
    await repository.updateRole(id, role);

    await loadUsers();
  }

  Future<void> delete(String id) async {
    await repository.deleteUser(id);

    await loadUsers();
  }
}
