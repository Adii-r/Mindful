class CategoryModel {
  final String id;
  final String name;
  final String icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory CategoryModel.fromMap(
      String id,
      Map<dynamic, dynamic> json,
      ) {
    return CategoryModel(
      id: id,
      name: json["name"] ?? "",
      icon: json["icon"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "icon": icon,
    };
  }
}