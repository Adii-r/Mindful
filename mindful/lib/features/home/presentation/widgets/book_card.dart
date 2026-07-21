import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class BookSection extends StatelessWidget {
  final List<Map<String, dynamic>> books;

  const BookSection({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          "Books Picked For You",

          style: AppTheme.titleLarge.copyWith(color: Colors.white),
        ),

        const SizedBox(height: 16),

        ListView.builder(
          shrinkWrap: true,

          physics: const NeverScrollableScrollPhysics(),

          itemCount: books.length,

          itemBuilder: (context, index) {
            final book = books[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 14),

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: AppTheme.surface,

                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    book["title"],

                    style: AppTheme.titleMedium.copyWith(color: Colors.white),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${book["authorName"]} • ${book["categoryId"]}",

                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
