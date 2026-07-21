import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserCredential> signIn({
    required String email,
    required String password,
  });

  Future<UserCredential> signUp({
    required String email,
    required String password,
  });

  Future<void> signOut();

  User? get currentUser;

  Future<UserCredential?> signInWithGoogle();
}