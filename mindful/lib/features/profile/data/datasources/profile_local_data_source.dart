import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/profile_model.dart';

class ProfileLocalDataSource {
  Future<ProfileModel> getProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final db = FirebaseDatabase.instance.ref();

    final userSnapshot =
    await db.child("users").child(uid).get();

    final prefSnapshot =
    await db.child("user_preferences").child(uid).get();

    String name = "User";
    String email = "";
    String? photoUrl;

    if (userSnapshot.exists) {
      final data = Map<String, dynamic>.from(
        userSnapshot.value as Map,
      );

      name = data["displayName"] ?? "User";
      email = data["email"] ?? "";
      photoUrl = data["photoUrl"];
    }

    final List<Map<String, dynamic>> interests = [];

    if (prefSnapshot.exists) {
      final prefData = Map<String, dynamic>.from(
        prefSnapshot.value as Map,
      );

      final ids = List<String>.from(
        prefData["categoryIds"] ?? [],
      );

      final categorySnapshot =
      await db.child("categories").get();

      if (categorySnapshot.exists) {
        final categories = Map<dynamic, dynamic>.from(
          categorySnapshot.value as Map,
        );

        for (final id in ids) {
          if (categories.containsKey(id)) {
            final category = Map<String, dynamic>.from(
              categories[id],
            );

            interests.add({
              "name": category["name"],
              "icon": category["icon"],
            });
          }
        }
      }
    }

    return ProfileModel(
      name: name,
      email: email,
      photoUrl: photoUrl,
      interests: interests,
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}