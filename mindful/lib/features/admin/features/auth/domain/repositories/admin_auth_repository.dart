import 'package:firebase_auth/firebase_auth.dart';

abstract class AdminAuthRepository {
  Future<UserCredential> signIn({
    required String email,
    required String password,
  });

  Future<bool> isAdmin(String uid);

  Future<void> signOut();
}