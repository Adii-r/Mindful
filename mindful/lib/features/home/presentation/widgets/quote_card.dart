import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class QuoteCard extends StatelessWidget {
  final Map<String, dynamic>? quote;
  final Map<String, dynamic>? author;

  const QuoteCard({super.key, this.quote, this.author});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,

        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                "Quote For You",
                style: AppTheme.titleMedium.copyWith(color: Colors.white),
              ),

              Icon(Icons.favorite_border, color: Colors.white),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            quote?["text"] ?? "Select your mood to get a quote",

            style: AppTheme.headlineLarge.copyWith(
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "— ${author?["name"] ?? "Mindful"}",

            style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
