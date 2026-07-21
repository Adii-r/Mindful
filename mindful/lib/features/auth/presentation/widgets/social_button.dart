import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String assetIcon;
  final VoidCallback? onPressed;

  const SocialButton({
    super.key,
    required this.text,
    required this.assetIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.05),
          side: BorderSide(
            color: Colors.white.withValues(alpha: .15),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetIcon,
              width: 22,
              height: 22,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}