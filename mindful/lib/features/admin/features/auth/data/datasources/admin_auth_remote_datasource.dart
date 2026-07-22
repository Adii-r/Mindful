import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminAuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<bool> isAdmin(String uid) async {
    final snapshot = await _db.child("users").child(uid).child("role").get();

    if (!snapshot.exists) {
      return false;
    }

    return snapshot.value == "admin";
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}