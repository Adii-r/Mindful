import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../favorites/presentation/providers/favorite_provider.dart';


class AuthorsSection extends ConsumerStatefulWidget {
  const AuthorsSection({super.key, required this.authors});

  final List<Map<String, dynamic>> authors;

  @override
  ConsumerState<AuthorsSection> createState() => _AuthorsSectionState();
}

class _AuthorsSectionState extends ConsumerState<AuthorsSection> {
  Set<String> favoriteAuthors = {};

  @override
  void initState() {
    super.initState();

    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favorites = await ref.read(favoriteProvider).getFavorites();

    if (!mounted) return;

    setState(() {
      favoriteAuthors = favorites
          .where((fav) => fav.itemType == "author")
          .map((fav) => fav.itemId)
          .toSet();
    });
  }

  Future<void> toggleAuthor(String id) async {
    await ref
        .read(favoriteProvider)
        .toggleFavorite(itemId: id, itemType: "author");

    loadFavorites();
  }

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

            itemCount: widget.authors.length,

            itemBuilder: (context, index) {
              final author = widget.authors[index];

              final saved = favoriteAuthors.contains(author["id"]);

              return Padding(
                padding: const EdgeInsets.only(right: 20),

                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 35,

                          backgroundColor: AppTheme.primary,

                          child: Text(
                            author["name"].substring(0, 1).toUpperCase(),

                            style: const TextStyle(
                              color: Colors.white,

                              fontSize: 28,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Positioned(
                          right: -2,

                          bottom: -2,

                          child: GestureDetector(
                            onTap: () {
                              toggleAuthor(author["id"]);
                            },

                            child: CircleAvatar(
                              radius: 13,

                              backgroundColor: AppTheme.surface,

                              child: Icon(
                                saved ? Icons.favorite : Icons.favorite_border,

                                color: Colors.red,

                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
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
