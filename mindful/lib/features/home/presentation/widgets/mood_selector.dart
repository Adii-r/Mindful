import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class MoodSelector extends StatelessWidget {
  final List<Map<String, dynamic>> moods;

  final String selectedMood;

  final Function(String moodId) onMoodSelected;

  const MoodSelector({
    super.key,

    required this.moods,

    required this.selectedMood,

    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          "How are you feeling right now?",

          style: AppTheme.titleLarge.copyWith(color: Colors.white),
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: moods.map((mood) {
            final isSelected = selectedMood == mood["id"];

            return GestureDetector(
              onTap: () {
                onMoodSelected(mood["id"]);
              },

              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),

                    width: 60,

                    height: 60,

                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.secondary : AppTheme.surface,

                      shape: BoxShape.circle,

                      border: Border.all(
                        color: isSelected
                            ? AppTheme.secondary
                            : Colors.transparent,
                      ),
                    ),

                    child: Center(
                      child: Text(
                        mood["emoji"] ?? "🙂",

                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    mood["name"] ?? "",

                    style: AppTheme.bodySmall.copyWith(
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
