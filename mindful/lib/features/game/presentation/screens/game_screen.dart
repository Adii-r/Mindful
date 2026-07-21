import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/answer_tile.dart';
import '../../data/models/game_model.dart';
import '../providers/game_provider.dart';


class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  List<GameModel> games = [];

  bool isLoading = true;

  int currentIndex = 0;

  int selectedAnswer = -1;

  bool answered = false;

  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    loadGames();
  }

  Future<void> loadGames() async {
    games = await ref.read(gameProvider).loadQuestions();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (games.isEmpty) {
      return const Scaffold(body: Center(child: Text("No Questions Found")));
    }

    final currentGame = games[currentIndex];

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Mindful Quiz",
          style: AppTheme.titleMedium.copyWith(color: Colors.white),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Question ${currentIndex + 1} of ${games.length}",
                style: AppTheme.titleMedium.copyWith(color: Colors.white),
              ),

              const SizedBox(height: 12),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: (currentIndex + 1) / games.length,
                  minHeight: 8,
                  backgroundColor: AppTheme.surface,
                  valueColor: AlwaysStoppedAnimation(AppTheme.primary),
                ),
              ),

              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      "Who said this?",
                      style: AppTheme.titleLarge.copyWith(color: Colors.white),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      currentGame.question,
                      textAlign: TextAlign.center,
                      style: AppTheme.titleMedium.copyWith(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentGame.options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return AnswerTile(
                    text: currentGame.options[index],
                    selected: selectedAnswer == index,
                    correct:
                        currentGame.options[index] == currentGame.correctAnswer,
                    answered: answered,
                    onTap: () {
                      if (answered) return;

                      setState(() {
                        selectedAnswer = index;
                        answered = true;

                        isCorrect =
                            currentGame.options[index] ==
                            currentGame.correctAnswer;
                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              if (answered)
                Center(
                  child: Text(
                    isCorrect
                        ? "✅ Correct!"
                        : "❌ Correct Answer: ${currentGame.correctAnswer}",
                    style: AppTheme.titleMedium.copyWith(
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              if (answered)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentIndex < games.length - 1) {
                        setState(() {
                          currentIndex++;
                          selectedAnswer = -1;
                          answered = false;
                          isCorrect = false;
                        });
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Quiz Completed 🎉"),
                            content: const Text(
                              "You've completed all available questions.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                  setState(() {
                                    currentIndex = 0;
                                    selectedAnswer = -1;
                                    answered = false;
                                    isCorrect = false;
                                  });
                                },
                                child: const Text("Play Again"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Next Question"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
