import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> createUserProfile(User user, {String provider = "email"}) async {
    final ref = FirebaseDatabase.instance.ref().child("users").child(user.uid);

    await ref.set({
      "displayName": user.displayName ?? "User",

      "email": user.email,

      "authProvider": provider,

      "createdAt": DateTime.now().millisecondsSinceEpoch,
    });

    await FirebaseDatabase.instance.ref().child("streaks").child(user.uid).set({
      "currentStreak": 0,

      "lastActiveDate": DateTime.now().toIso8601String(),
    });
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    await credential.user!.updateDisplayName(username);
    await credential.user!.reload();

    await createUserProfile(
      _firebaseAuth.currentUser!,
      provider: "email",
    );

    return credential;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    final userExists = await FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(userCredential.user!.uid)
        .get();

    if (!userExists.exists) {
      await createUserProfile(
        userCredential.user!,
        provider: "google",
      );
    }

    return userCredential;
  }
}
