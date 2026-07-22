import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repositories/admin_auth_repository.dart';
import '../datasources/admin_auth_remote_datasource.dart';

class AdminAuthRepositoryImpl implements AdminAuthRepository {
  final AdminAuthRemoteDataSource remote;

  AdminAuthRepositoryImpl(this.remote);

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return remote.signIn(
      email: email,
      password: password,
    );
  }

  @override
  Future<bool> isAdmin(String uid) {
    return remote.isAdmin(uid);
  }

  @override
  Future<void> signOut() {
    return remote.signOut();
  }
}