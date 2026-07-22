class BookModel {
  final String id;
  final String title;
  final String authorId;
  final String categoryId;

  BookModel({
    required this.id,
    required this.title,
    required this.authorId,
    required this.categoryId,
  });

  factory BookModel.fromJson(String id, Map<dynamic, dynamic> json) {
    return BookModel(
      id: id,
      title: json['title'] ?? "",
      authorId: json['authorId'] ?? "",
      categoryId: json['categoryId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "authorId": authorId, "categoryId": categoryId};
  }
}
