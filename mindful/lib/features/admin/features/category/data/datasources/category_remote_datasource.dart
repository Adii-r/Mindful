import 'package:firebase_database/firebase_database.dart';
import '../models/category_model.dart';


class CategoryRemoteDataSource {
  final DatabaseReference _db =
  FirebaseDatabase.instance.ref();

  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _db.child("categories").get();

    if (!snapshot.exists) return [];

    final map = snapshot.value as Map<dynamic, dynamic>;

    return map.entries
        .map(
          (e) => CategoryModel.fromMap(
        e.key,
        e.value,
      ),
    )
        .toList();
  }

  Future<void> addCategory(CategoryModel category) async {
    await _db
        .child("categories")
        .child(category.id)
        .set(category.toMap());
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _db
        .child("categories")
        .child(category.id)
        .update(category.toMap());
  }

  Future<void> deleteCategory(String id) async {
    await _db
        .child("categories")
        .child(id)
        .remove();
  }
}