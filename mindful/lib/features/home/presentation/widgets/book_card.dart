import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../favorites/presentation/providers/favorite_provider.dart';
import '../screens/book_detail_screen.dart';

class BookSection extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> books;

  const BookSection({super.key, required this.books});

  @override
  ConsumerState<BookSection> createState() => _BookSectionState();
}

class _BookSectionState extends ConsumerState<BookSection> {
  Set<String> favoriteBooks = {};

  @override
  void initState() {
    super.initState();

    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favorites = await ref.read(favoriteProvider).getFavorites();

    if (!mounted) return;

    setState(() {
      favoriteBooks = favorites
          .where((fav) => fav.itemType == "book")
          .map((fav) => fav.itemId)
          .toSet();
    });
  }

  Future<void> toggleBook(String id) async {
    await ref
        .read(favoriteProvider)
        .toggleFavorite(itemId: id, itemType: "book");

    loadFavorites();
  }

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
      
            itemCount: widget.books.length,
      
            itemBuilder: (context, index) {
              final book = widget.books[index];
      
              final saved = favoriteBooks.contains(book["id"]);

              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailScreen(
                          book: Map<String, dynamic>.from(book),
                        ),
                      ),
                    );
                  },

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
      
                padding: const EdgeInsets.all(16),
      
                decoration: BoxDecoration(
                  color: AppTheme.surface,
      
                  borderRadius: BorderRadius.circular(18),
                ),
      
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
      
                        children: [
                          Text(
                            book["title"],
      
                            style: AppTheme.titleMedium.copyWith(
                              color: Colors.white,
                            ),
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
                    ),
      
                    IconButton(
                      onPressed: () {
                        toggleBook(book["id"]);
                      },
      
                      icon: Icon(
                        saved ? Icons.favorite : Icons.favorite_border,
      
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              );
            },
          ),
        ],
    );
  }
}
