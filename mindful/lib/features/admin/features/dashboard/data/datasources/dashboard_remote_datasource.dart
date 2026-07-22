import 'package:firebase_database/firebase_database.dart';

import '../models/dashboard_model.dart';

class DashboardRemoteDataSource {
  final DatabaseReference db = FirebaseDatabase.instance.ref();

  Future<DashboardModel> getDashboard() async {
    final categories =
    await db.child("categories").get();

    final authors =
    await db.child("authors").get();

    final books =
    await db.child("books").get();

    final quotes =
    await db.child("quotes").get();

    final games =
    await db.child("game_content").get();

    final users =
    await db.child("users").get();

    return DashboardModel(
      categories:
      categories.children.length,
      authors:
      authors.children.length,
      books:
      books.children.length,
      quotes:
      quotes.children.length,
      games:
      games.children.length,
      users:
      users.children.length,
    );
  }
}