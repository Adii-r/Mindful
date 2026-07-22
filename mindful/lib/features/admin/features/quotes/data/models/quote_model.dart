class QuoteModel {
  final String id;
  final String text;
  final String authorId;
  final String categoryId;
  final String moodId;

  QuoteModel({
    required this.id,
    required this.text,
    required this.authorId,
    required this.categoryId,
    required this.moodId,
  });

  factory QuoteModel.fromJson(String id, Map<dynamic, dynamic> json) {
    return QuoteModel(
      id: id,

      text: json['text'] ?? "",

      authorId: json['authorId'] ?? "",

      categoryId: json['categoryId'] ?? "",

      moodId: json['moodId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "text": text,

      "authorId": authorId,

      "categoryId": categoryId,

      "moodId": moodId,
    };
  }
}
