class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final String correctanswer;
  final String authorId;
  final String difficulty;

  QuestionModel({
    required this.id,

    required this.question,

    required this.options,

    required this.correctanswer,

    required this.authorId,

    required this.difficulty,
  });

  factory QuestionModel.fromJson(String id, Map<String, dynamic> json) {
    return QuestionModel(
      id: id,

      question: json["question"] ?? "",

      options: List<String>.from(json["options"] ?? []),

      correctanswer: json["correctAnswer"] ?? "",

      authorId: json["authorId"] ?? "",

      difficulty: json["difficulty"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,

      "options": options,

      "correctAnswer": correctanswer,

      "authorId": authorId,

      "difficulty": difficulty,
    };
  }
}
