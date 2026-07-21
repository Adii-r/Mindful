class CategoryModel {
  final String id;
  final String name;
  final String iconUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  factory CategoryModel.fromMap(
      String id,
      Map<dynamic, dynamic> map,
      ) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      iconUrl: map['iconUrl'] ?? '',
    );
  }
}