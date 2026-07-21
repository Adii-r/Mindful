import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../favorites/presentation/providers/favorite_provider.dart';

class BookDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> book;

  const BookDetailScreen({super.key, required this.book});

  @override
  ConsumerState<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends ConsumerState<BookDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    checkFavorite();
  }

  Future<void> checkFavorite() async {
    final result = await ref
        .read(favoriteProvider)
        .isFavorite(itemId: widget.book["id"], itemType: "book");

    setState(() {
      isFavorite = result;
    });
  }

  Future<void> toggleFavorite() async {
    await ref
        .read(favoriteProvider)
        .toggleFavorite(itemId: widget.book["id"], itemType: "book");

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 320,

              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/background.png",
                    width: double.infinity,
                    height: 320,
                    fit: BoxFit.cover,
                  ),

                  Container(color: Colors.black.withValues(alpha: 0.2)),

                  SafeArea(
                    child: Align(
                      alignment: Alignment.topLeft,

                      child: Padding(
                        padding: const EdgeInsets.all(16),

                        child: CircleAvatar(
                          backgroundColor: Colors.white,

                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),

                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              transform: Matrix4.translationValues(0, -40, 0),

              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(30),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: AppTheme.primary,

                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Text(
                      widget.book["authorName"] ?? "Unknown Author",

                      style: const TextStyle(
                        color: Colors.white,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    widget.book["title"],

                    style: const TextStyle(
                      fontFamily: "CormorantGaramond",

                      fontSize: 38,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: const Color(0xffEAF8EF),

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text("Category", style: AppTheme.bodyMedium),

                        const SizedBox(height: 8),

                        Text(
                          widget.book["categoryId"],

                          style: AppTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: toggleFavorite,

                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),

                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.primary),

                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Column(
                              children: [
                                Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,

                                  color: AppTheme.primary,
                                ),

                                const SizedBox(height: 10),

                                Text(isFavorite ? "Saved" : "Save"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
