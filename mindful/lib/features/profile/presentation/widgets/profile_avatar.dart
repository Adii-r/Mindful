import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final String name;

  const ProfileAvatar({
    super.key,
    required this.photoUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 52,
      backgroundColor: AppTheme.primary,
      backgroundImage:
      photoUrl != null ? NetworkImage(photoUrl!) : null,
      child: photoUrl == null
          ? Text(
        name.isNotEmpty ? name[0].toUpperCase() : "E",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      )
          : null,
    );
  }
}