import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class InterestChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const InterestChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primary
                  : Colors.white24,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}