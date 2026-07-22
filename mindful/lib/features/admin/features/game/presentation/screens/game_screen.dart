import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/question_model.dart';
import '../providers/game_provider.dart';

class GamesAdminScreen extends ConsumerWidget {
  const GamesAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(gameProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,

        onPressed: () {
          showQuestionDialog(context, ref);
        },

        icon: const Icon(Icons.add),
        label: const Text("Add Question"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Game Questions",

              style: AppTheme.displayLarge.copyWith(color: AppTheme.white),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: AppTheme.surface,

                  borderRadius: BorderRadius.circular(22),
                ),

                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 1300),

                    child: DataTable(
                      columnSpacing: 100,

                      headingRowHeight: 70,

                      dataRowHeight: 80,

                      headingRowColor: WidgetStateProperty.all(
                        AppTheme.background,
                      ),

                      headingTextStyle: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold,
                      ),

                      dataTextStyle: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textPrimary,
                      ),

                      columns: const [
                        DataColumn(label: Text("Question")),

                        DataColumn(label: Text("Difficulty")),

                        DataColumn(label: Text("Answer")),

                        DataColumn(label: Text("Actions")),
                      ],

                      rows: questions.map((question) {
                        return DataRow(
                          cells: [
                            DataCell(
                              SizedBox(
                                width: 450,

                                child: Text(
                                  question.question,

                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                            DataCell(Text(question.difficulty)),

                            DataCell(
                              SizedBox(
                                width: 200,

                                child: Text(
                                  question.correctanswer,

                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),

                                    onPressed: () {
                                      showQuestionDialog(
                                        context,
                                        ref,
                                        question: question,
                                      );
                                    },
                                  ),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),

                                    onPressed: () async {
                                      await ref
                                          .read(gameProvider.notifier)
                                          .delete(question.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showQuestionDialog(
  BuildContext context,

  WidgetRef ref, {

  QuestionModel? question,
}) async {
  final questionController = TextEditingController(
    text: question?.question ?? "",
  );

  final options = List.generate(4, (index) {
    return TextEditingController(
      text: question != null && question.options.length > index
          ? question.options[index]
          : "",
    );
  });

  final answerController = TextEditingController(
    text: question?.correctanswer ?? "",
  );

  final difficultyController = TextEditingController(
    text: question?.difficulty ?? "easy",
  );

  final editing = question != null;

  await showDialog(
    context: context,

    builder: (context) {
      return AlertDialog(
        backgroundColor: AppTheme.surface,

        title: Text(
          editing ? "Edit Question" : "Add Question",

          style: AppTheme.titleLarge.copyWith(color: AppTheme.white),
        ),

        content: SizedBox(
          width: 450,

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                buildField(questionController, "Question"),

                ...options.asMap().entries.map((e) {
                  return buildField(e.value, "Option ${e.key + 1}");
                }),

                buildField(answerController, "Correct Answer"),

                buildField(difficultyController, "Difficulty"),
              ],
            ),
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },

            child: const Text("Cancel"),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),

            onPressed: () async {
              final notifier = ref.read(gameProvider.notifier);

              final id = editing
                  ? question.id
                  : "game_${DateTime.now().millisecondsSinceEpoch}";

              final data = QuestionModel(
                id: id,

                question: questionController.text.trim(),

                options: options.map((e) => e.text.trim()).toList(),

                correctanswer: answerController.text.trim(),

                authorId: question?.authorId ?? "",

                difficulty: difficultyController.text.trim(),
              );

              if (editing) {
                await notifier.update(data);
              } else {
                await notifier.add(data);
              }

              if (context.mounted) {
                Navigator.pop(context);
              }
            },

            child: Text(
              editing ? "Update" : "Save",

              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

Widget buildField(TextEditingController controller, String hint) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),

    child: TextField(
      controller: controller,

      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: TextStyle(color: Colors.grey.shade400),

        filled: true,

        fillColor: AppTheme.background,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
