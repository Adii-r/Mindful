import 'package:firebase_database/firebase_database.dart';

import '../models/question_model.dart';

class GameRemoteDataSource {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<List<QuestionModel>> getQuestions() async {
    final snapshot = await _db.child("game_content").get();

    if (!snapshot.exists) {
      return [];
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return data.entries.map((entry) {
      final value = Map<String, dynamic>.from(entry.value as Map);

      return QuestionModel(
        id: entry.key,

        question: value["question"] ?? "",

        options: List<String>.from(value["options"] ?? []),

        correctanswer: value["correctAnswer"] ?? "",

        authorId: value["authorId"] ?? "",

        difficulty: value["difficulty"] ?? "easy",
      );
    }).toList();
  }

  Future<void> addQuestion(QuestionModel question) async {
    await _db.child("game_content").child(question.id).set(question.toJson());
  }

  Future<void> updateQuestion(QuestionModel question) async {
    await _db
        .child("game_content")
        .child(question.id)
        .update(question.toJson());
  }

  Future<void> deleteQuestion(String id) async {
    await _db.child("game_content").child(id).remove();
  }
}
