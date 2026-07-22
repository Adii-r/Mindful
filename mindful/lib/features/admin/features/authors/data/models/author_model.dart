class AuthorModel {
  final String id;
  final String name;
  final String bio;
  final String categoryId;

  AuthorModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.categoryId,
  });

  factory AuthorModel.fromMap(String id, Map<dynamic, dynamic> data) {
    return AuthorModel(
      id: id,
      name: data["name"] ?? "",
      bio: data["bio"] ?? "",
      categoryId: data["categoryId"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "bio": bio, "categoryId": categoryId};
  }
}
