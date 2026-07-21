class Profile {
  final String name;
  final String email;
  final String? photoUrl;
  final List<Map<String, dynamic>> interests;

  const Profile({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.interests,
  });
}