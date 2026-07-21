import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return remoteDataSource.signInWithEmail(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) {
    return remoteDataSource.signUpWithEmail(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() {
    return remoteDataSource.signOut();
  }

  @override
  User? get currentUser => remoteDataSource.currentUser;

  @override
  Future<UserCredential?> signInWithGoogle() {
    return remoteDataSource.signInWithGoogle();
  }
}

