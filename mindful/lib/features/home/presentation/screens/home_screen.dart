import 'package:flutter/material.dart';
import 'package:mindful/features/home/presentation/widgets/author_card.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/book_card.dart';
import '../widgets/mood_selector.dart';
import '../widgets/quote_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        "Good Evening,",
                        style: AppTheme.bodyLarge.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Aditya",
                        style: AppTheme.headlineLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),

                    ],
                  ),


                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Row(
                      children: [

                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          "7",
                          style: AppTheme.titleMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 32),
              const MoodSelector(),
              const SizedBox(height: 32),
              const QuoteCard(),
              const SizedBox(height:32),
              const AuthorsSection(),
              const SizedBox(height:32),
              const BooksSection(),

            ],

          ),


        ),
      ),
    );
  }
}