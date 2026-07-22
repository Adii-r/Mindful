import 'package:firebase_database/firebase_database.dart';

import '../models/book_model.dart';

class BookRemoteDataSource {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<List<BookModel>> getBooks() async {
    final snapshot = await _db.child("books").get();

    if (!snapshot.exists) {
      return [];
    }

    final data = snapshot.value as Map<dynamic, dynamic>;

    return data.entries.map((entry) {
      return BookModel.fromJson(entry.key, entry.value);
    }).toList();
  }

  Future<void> addBook(BookModel book) async {
    await _db.child("books").child(book.id).set(book.toJson());
  }

  Future<void> updateBook(BookModel book) async {
    await _db.child("books").child(book.id).update(book.toJson());
  }

  Future<void> deleteBook(String id) async {
    await _db.child("books").child(id).remove();
  }
}
