import 'package:firebase_database/firebase_database.dart';

import '../models/game_model.dart';

class GameRemoteDataSource {
  final DatabaseReference _database =
  FirebaseDatabase.instance.ref();

  Future<List<GameModel>> loadQuestions() async {
    final snapshot =
    await _database.child("game_content").get();

    if (!snapshot.exists) {
      return [];
    }

    final data =
    Map<dynamic, dynamic>.from(snapshot.value as Map);

    return data.entries.map((entry) {
      return GameModel.fromMap(
        entry.key,
        Map<dynamic, dynamic>.from(entry.value),
      );
    }).toList();
  }
}