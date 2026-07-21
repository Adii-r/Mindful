import 'package:flutter/material.dart';

import '../../../auth/presentation/widgets/primary_button.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: "Logout",
      onPressed: onPressed,
    );
  }
}