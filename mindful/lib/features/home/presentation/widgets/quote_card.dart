import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../favorites/presentation/providers/favorite_provider.dart';

class QuoteCard extends ConsumerStatefulWidget {
  final Map<String, dynamic>? quote;

  final Map<String, dynamic>? author;

  const QuoteCard({super.key, this.quote, this.author});

  @override
  ConsumerState<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends ConsumerState<QuoteCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    checkFavorite();
  }

  Future<void> checkFavorite() async {
    if (widget.quote == null) return;

    final favorites = await ref.read(favoriteProvider).getFavorites();

    final exists = favorites.any(
      (fav) => fav.itemId == widget.quote!["id"] && fav.itemType == "quote",
    );

    if (!mounted) return;

    setState(() {
      isFavorite = exists;
    });
  }

  Future<void> toggleFavorite() async {
    if (widget.quote == null) return;

    await ref
        .read(favoriteProvider)
        .toggleFavorite(itemId: widget.quote!["id"], itemType: "quote");

    setState(() {
      isFavorite = !isFavorite;
    });
  }

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

              IconButton(
                onPressed: toggleFavorite,

                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,

                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            widget.quote?["text"] ?? "Select your mood to get a quote",

            style: AppTheme.headlineLarge.copyWith(
              color: Colors.white,

              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "— ${widget.author?["name"] ?? "Mindful"}",

            style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
