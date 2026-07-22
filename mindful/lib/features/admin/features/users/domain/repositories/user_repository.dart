import '../../data/models/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> getUsers();

  Future<void> updateRole(String id, String role);

  Future<void> deleteUser(String id);
}
