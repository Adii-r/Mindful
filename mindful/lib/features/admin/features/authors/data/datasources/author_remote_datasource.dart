import 'package:firebase_database/firebase_database.dart';

import '../models/author_model.dart';

class AuthorRemoteDataSource {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<List<AuthorModel>> getAuthors() async {
    final snapshot = await _db.child("authors").get();

    List<AuthorModel> authors = [];

    if (snapshot.exists) {
      final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

      data.forEach((key, value) {
        authors.add(AuthorModel.fromMap(key, value));
      });
    }

    return authors;
  }

  Future<void> addAuthor(AuthorModel author) async {
    await _db.child("authors").child(author.id).set(author.toMap());
  }

  Future<void> updateAuthor(AuthorModel author) async {
    await _db.child("authors").child(author.id).update(author.toMap());
  }

  Future<void> deleteAuthor(String id) async {
    await _db.child("authors").child(id).remove();
  }
}
