class GameModel {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String authorId;

  GameModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.authorId,
  });

  factory GameModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return GameModel(
      id: id,
      question: map["question"] ?? "",
      options: List<String>.from(map["options"] ?? []),
      correctAnswer: map["correctAnswer"] ?? "",
      authorId: map["authorId"] ?? "",
    );
  }
}