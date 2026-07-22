class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String role;
  final String authProvider;
  final String createdAt;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.role,
    required this.authProvider,
    required this.createdAt,
  });

  factory UserModel.fromJson(String id, Map<String, dynamic> json) {
    return UserModel(
      id: id,

      displayName: json["displayName"] ?? "",

      email: json["email"] ?? "",

      role: json["role"] ?? "user",

      authProvider: json["authProvider"] ?? "",

      createdAt: json["createdAt"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "displayName": displayName,

      "email": email,

      "role": role,

      "authProvider": authProvider,

      "createdAt": createdAt,
    };
  }
}
