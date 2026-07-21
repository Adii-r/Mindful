import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AuthorsSection extends StatelessWidget {
  final List<Map<String, dynamic>> authors;

  const AuthorsSection({super.key, required this.authors});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Authors For You",
          style: AppTheme.titleLarge.copyWith(color: Colors.white),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 120,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,

            itemCount: authors.length,

            itemBuilder: (context, index) {
              final author = authors[index];

              return Padding(
                padding: const EdgeInsets.only(right: 20),

                child: Column(
                  children: [
                    Container(
                      height: 70,
                      width: 70,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        gradient: LinearGradient(
                          colors: [AppTheme.primary, AppTheme.secondary],
                        ),
                      ),

                      child: Center(
                        child: Text(
                          author["name"]
                              .toString()
                              .substring(0, 1)
                              .toUpperCase(),

                          style: const TextStyle(
                            color: Colors.white,

                            fontSize: 28,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: 80,

                      child: Text(
                        author["name"],

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        textAlign: TextAlign.center,

                        style: AppTheme.bodySmall.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
