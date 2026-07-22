import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';

import '../../data/models/quote_model.dart';

import '../providers/quote_provider.dart';
import '../../../authors/presentation/providers/author_provider.dart';
import '../../../category/presentation/providers/category_provider.dart';

class QuotesScreen extends ConsumerWidget {
  const QuotesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotes = ref.watch(quoteProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,

        foregroundColor: Colors.white,

        onPressed: () {
          showQuoteDialog(context, ref);
        },

        icon: const Icon(Icons.add),

        label: const Text("Add Quote"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Quotes",

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
                    constraints: const BoxConstraints(minWidth: 1600),

                    child: SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 150,

                        horizontalMargin: 40,

                        dataRowHeight: 75,

                        headingRowHeight: 70,

                        headingRowColor: WidgetStateProperty.all(
                          AppTheme.background,
                        ),

                        headingTextStyle: AppTheme.bodyLarge.copyWith(
                          color: AppTheme.white,

                          fontWeight: FontWeight.bold,
                        ),

                        dataTextStyle: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.white,
                        ),

                        columns: const [
                          DataColumn(label: Text("Quote")),

                          DataColumn(label: Text("Author")),

                          DataColumn(label: Text("Category")),

                          DataColumn(label: Text("Mood")),

                          DataColumn(label: Text("Actions")),
                        ],

                        rows: quotes.map((quote) {
                          return DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: 350,

                                  child: Text(
                                    quote.text,

                                    overflow: TextOverflow.ellipsis,

                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),
                              ),

                              DataCell(
                                Text(
                                  quote.authorId,

                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),

                              DataCell(
                                Text(
                                  quote.categoryId,

                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),

                              DataCell(
                                Text(
                                  quote.moodId,

                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.white,
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
                                        showQuoteDialog(
                                          context,
                                          ref,

                                          quote: quote,
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
                                            .read(quoteProvider.notifier)
                                            .delete(quote.id);
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
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showQuoteDialog(
  BuildContext context,

  WidgetRef ref, {

  QuoteModel? quote,
}) async {
  final textController = TextEditingController(text: quote?.text ?? "");

  String author = quote?.authorId ?? "";

  String category = quote?.categoryId ?? "";

  String mood = quote?.moodId ?? "";

  final editing = quote != null;

  await showDialog(
    context: context,

    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final authors = ref.read(authorProvider);

          final categories = ref.read(categoryProvider);

          return AlertDialog(
            backgroundColor: AppTheme.surface,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),

            title: Text(
              editing ? "Edit Quote" : "Add Quote",

              style: AppTheme.titleLarge.copyWith(color: AppTheme.white),
            ),

            content: SizedBox(
              width: 450,

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  TextField(
                    controller: textController,

                    maxLines: 3,

                    style: const TextStyle(color: Colors.white),

                    decoration: inputDecoration("Quote Text"),
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: author.isEmpty ? null : author,

                    dropdownColor: AppTheme.surface,

                    style: const TextStyle(color: Colors.white),

                    decoration: inputDecoration("Author"),

                    items: authors.map((e) {
                      return DropdownMenuItem(
                        value: e.id,

                        child: Text(
                          e.name,

                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        author = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: category.isEmpty ? null : category,

                    dropdownColor: AppTheme.surface,

                    style: const TextStyle(color: Colors.white),

                    decoration: inputDecoration("Category"),

                    items: categories.map((e) {
                      return DropdownMenuItem(
                        value: e.id,

                        child: Text(
                          e.name,

                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        category = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text(
                  "Cancel",

                  style: TextStyle(color: Colors.white),
                ),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),

                onPressed: () async {
                  final notifier = ref.read(quoteProvider.notifier);

                  final id = textController.text
                      .trim()
                      .toLowerCase()
                      .replaceAll(" ", "_");

                  if (editing) {
                    await notifier.update(
                      QuoteModel(
                        id: quote.id,

                        text: textController.text.trim(),

                        authorId: author,

                        categoryId: category,

                        moodId: mood,
                      ),
                    );
                  } else {
                    await notifier.add(
                      QuoteModel(
                        id: id,

                        text: textController.text.trim(),

                        authorId: author,

                        categoryId: category,

                        moodId: mood,
                      ),
                    );
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
    },
  );
}

InputDecoration inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,

    hintStyle: AppTheme.bodyMedium.copyWith(color: AppTheme.hint),

    labelStyle: AppTheme.bodyMedium.copyWith(color: AppTheme.hint),

    filled: true,

    fillColor: AppTheme.background,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  );
}
