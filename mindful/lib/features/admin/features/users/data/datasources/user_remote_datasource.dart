import 'package:firebase_database/firebase_database.dart';

import '../models/user_model.dart';

class UserRemoteDataSource {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<List<UserModel>> getUsers() async {
    final snapshot = await _db.child("users").get();

    print("FIREBASE USERS:");
    print(snapshot.value);

    if (!snapshot.exists) {
      return [];
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return data.entries.map((entry) {
      return UserModel.fromJson(
        entry.key,

        Map<String, dynamic>.from(entry.value),
      );
    }).toList();
  }

  Future<void> updateRole(String id, String role) async {
    await _db.child("users").child(id).update({"role": role});
  }

  Future<void> deleteUser(String id) async {
    await _db.child("users").child(id).remove();
  }
}
