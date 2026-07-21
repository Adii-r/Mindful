import 'package:firebase_database/firebase_database.dart';

class CategoryRemoteDataSource {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<DataSnapshot> getCategories() async {
    return await _db.child('categories').get();
  }

  Future<void> saveUserPreferences({
    required String uid,
    required List<String> categoryIds,
  }) async {
    await _db.child('user_preferences').child(uid).set({
      'categoryIds': categoryIds,
    });
  }
}