import 'package:flutter/material.dart';
import 'package:mindful/features/home/presentation/widgets/author_card.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/book_card.dart';
import '../widgets/mood_selector.dart';
import '../widgets/quote_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "User";
  int streak = 0;
  Map<String, dynamic>? selectedQuote;
  List<Map<String, dynamic>> quotes = [];
  List<Map<String, dynamic>> authors = [];
  List<Map<String, dynamic>> books = [];
  Map<String, dynamic>? selectedAuthor;
  bool isLoading = true;
  String selectedMood = "";
  List<Map<String, dynamic>> recommendedAuthors = [];
  List<Map<String, dynamic>> recommendedBooks = [];
  List<Map<String, dynamic>> moods = [];

  Future<void> loadMoods() async {
    final snapshot = await FirebaseDatabase.instance.ref().child("moods").get();

    if (!snapshot.exists) return;

    final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

    setState(() {
      moods = data.entries.map((e) {
        return {"id": e.key, ...Map<String, dynamic>.from(e.value)};
      }).toList();
    });
  }

  Future<void> loadRecommendedBooks() async {
    final categories = await loadUserCategories();

    final snapshot = await FirebaseDatabase.instance.ref().child("books").get();

    if (!snapshot.exists) return;

    final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

    List<Map<String, dynamic>> tempBooks = [];

    for (final entry in data.entries) {
      final book = Map<String, dynamic>.from(entry.value);

      if (categories.contains(book["categoryId"])) {
        final authorSnapshot = await FirebaseDatabase.instance
            .ref()
            .child("authors")
            .child(book["authorId"])
            .get();

        String authorName = "";

        if (authorSnapshot.exists) {
          final author = Map<String, dynamic>.from(
            authorSnapshot.value as Map<dynamic, dynamic>,
          );

          authorName = author["name"] ?? "";
        }

        tempBooks.add({"id": entry.key, ...book, "authorName": authorName});
      }
    }

    setState(() {
      recommendedBooks = tempBooks;
    });
  }

  Future<List<String>> loadUserCategories() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child("user_preferences")
        .child(uid)
        .get();

    if (!snapshot.exists) {
      return [];
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return List<String>.from(data["categoryIds"]);
  }

  Future<void> loadRecommendedAuthors() async {
    final categories = await loadUserCategories();

    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child("authors")
        .get();

    if (!snapshot.exists) return;

    final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

    final filteredAuthors = data.entries
        .where((entry) {
          final author = Map<String, dynamic>.from(entry.value);

          return categories.contains(author["categoryId"]);
        })
        .map((entry) {
          return {"id": entry.key, ...Map<String, dynamic>.from(entry.value)};
        })
        .toList();

    setState(() {
      recommendedAuthors = filteredAuthors;
    });
  }

  Future<void> loadHomeData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    print("CURRENT UID: $uid");

    final db = FirebaseDatabase.instance.ref();

    await loadMoods();

    final userSnapshot = await db.child("users").child(uid).get();

    if (userSnapshot.exists) {
      final data = Map<String, dynamic>.from(userSnapshot.value as Map);

      username = data["displayName"] ?? "User";
    }

    final streakSnapshot = await db.child("streaks").child(uid).get();

    if (streakSnapshot.exists) {
      final data = Map<String, dynamic>.from(streakSnapshot.value as Map);

      streak = data["currentStreak"] ?? 0;
    }

    final quoteSnapshot = await db.child("quotes").get();

    if (quoteSnapshot.exists) {
      final data = Map<dynamic, dynamic>.from(quoteSnapshot.value as Map);

      quotes = data.entries.map((e) {
        return {"id": e.key, ...Map<String, dynamic>.from(e.value)};
      }).toList();
    }

    final authorSnapshot = await db.child("authors").get();
    if (authorSnapshot.exists) {
      final data = Map<dynamic, dynamic>.from(authorSnapshot.value as Map);
      authors = data.entries.map((e) {
        return {"id": e.key, ...Map<String, dynamic>.from(e.value)};
      }).toList();
    }

    final bookSnapshot = await db.child("books").get();
    if (bookSnapshot.exists) {
      final data = Map<dynamic, dynamic>.from(bookSnapshot.value as Map);
      books = data.entries.map((e) {
        return {"id": e.key, ...Map<String, dynamic>.from(e.value)};
      }).toList();
    }
    await loadRecommendedAuthors();
    await loadRecommendedBooks();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveMood(String mood) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final ref = FirebaseDatabase.instance
        .ref()
        .child("mood_logs")
        .child(uid)
        .push();

    await ref.set({
      "moodId": mood,

      "loggedAt": DateTime.now().millisecondsSinceEpoch,
    });

    setState(() {
      selectedMood = mood;
    });

    loadMoodQuote(mood);
  }

  Future<void> loadMoodQuote(String moodId) async {
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child("quotes")
        .get();

    if (!snapshot.exists) return;

    final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

    for (final item in data.entries) {
      final quote = Map<String, dynamic>.from(item.value);

      if (quote["moodId"] == moodId) {
        setState(() {
          selectedQuote = {"id": item.key, ...quote};
        });

        await loadQuoteAuthor(quote["authorId"]);

        break;
      }
    }
  }

  Future<void> loadQuoteAuthor(String authorId) async {
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child("authors")
        .child(authorId)
        .get();

    if (!snapshot.exists) return;

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    setState(() {
      selectedAuthor = {"id": authorId, ...data};
    });
  }

  @override
  void initState() {
    super.initState();
    loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Good Evening,",
                        style: AppTheme.bodyLarge.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        username,
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
                          streak.toString(),
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
              MoodSelector(
                moods: moods,
                selectedMood: selectedMood,
                onMoodSelected: saveMood,
              ),
              const SizedBox(height: 32),
              QuoteCard(quote: selectedQuote, author: selectedAuthor),
              const SizedBox(height: 32),
              AuthorsSection(authors: recommendedAuthors),
              const SizedBox(height: 32),
              BookSection(books: recommendedBooks),
            ],
          ),
        ),
      ),
    );
  }
}
