import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_theme.dart';

class AnswerTile extends StatelessWidget {
  final String text;
  final bool selected;
  final bool correct;
  final bool answered;
  final VoidCallback onTap;

  const AnswerTile({
    super.key,
    required this.text,
    required this.selected,
    required this.correct,
    required this.answered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color background = AppTheme.surface;
    Color border = AppTheme.surface;

    if (answered) {
      if (correct) {
        background = Colors.green.shade100;
        border = Colors.green;
      } else if (selected) {
        background = Colors.red.shade100;
        border = Colors.red;
      }
    }

    return GestureDetector(
      onTap: answered ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: border,
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: AppTheme.bodyLarge.copyWith(
            color: answered && correct
                ? Colors.green.shade900
                : answered && selected
                ? Colors.red.shade900
                : Colors.white,
          ),
        ),
      ),
    );
  }
}