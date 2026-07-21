import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/favorite_provider.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  int selectedTab = 0;

  final tabs = ["Books", "Authors", "Quotes"];

  bool isLoading = true;

  List favorites = [];

  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();

    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data = await ref.read(favoriteProvider).getFavorites();

    favorites = data;

    await loadItems();
  }

  Future<void> loadItems() async {
    setState(() {
      isLoading = true;
    });

    String type;

    if (selectedTab == 0) {
      type = "book";
    } else if (selectedTab == 1) {
      type = "author";
    } else {
      type = "quote";
    }

    List<Map<String, dynamic>> loaded = [];

    for (final fav in favorites) {
      if (fav.itemType == type) {
        final item = await ref
            .read(favoriteProvider)
            .getItem(id: fav.itemId, type: type);

        if (item != null) {
          loaded.add(item);
        }
      }
    }

    if (!mounted) return;

    setState(() {
      items = loaded;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(
          "FAVORITES",

          style: TextStyle(
            fontFamily: "Inter",

            fontWeight: FontWeight.w900,

            fontSize: 24,

            letterSpacing: 6,

            color: Colors.white,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: List.generate(tabs.length, (index) {
                final selected = selectedTab == index;

                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      selectedTab = index;
                    });

                    await loadItems();
                  },

                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),

                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,

                      vertical: 12,
                    ),

                    decoration: BoxDecoration(
                      color: selected ? AppTheme.primary : AppTheme.surface,

                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Text(
                      tabs[index],

                      style: const TextStyle(
                        color: Colors.white,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : items.isEmpty
                  ? Center(
                      child: Text(
                        "No saved ${tabs[selectedTab]}",

                        style: const TextStyle(
                          color: Colors.white70,

                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),

                      itemCount: items.length,

                      itemBuilder: (context, index) {
                        final item = items[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),

                          padding: const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            color: AppTheme.surface,

                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                selectedTab == 0
                                    ? item["title"]
                                    : selectedTab == 1
                                    ? item["name"]
                                    : item["text"],

                                style: AppTheme.titleMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 8),

                              if (selectedTab == 0)
                                Text(
                                  item["authorName"] ?? "",

                                  style: AppTheme.bodyMedium.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),

                              if (selectedTab == 2)
                                Text(
                                  "- ${item["authorName"] ?? ""}",

                                  style: AppTheme.bodyMedium.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
