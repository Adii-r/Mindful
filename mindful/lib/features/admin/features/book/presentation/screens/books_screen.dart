import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';

import '../../data/models/book_model.dart';

import '../providers/book_provider.dart';
import '../../../authors/presentation/providers/author_provider.dart';
import '../../../category/presentation/providers/category_provider.dart';

class BooksScreen extends ConsumerWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(bookProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,

        foregroundColor: Colors.white,

        onPressed: () {
          showBookDialog(context, ref);
        },

        icon: const Icon(Icons.add),

        label: const Text("Add Book"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Books",

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

                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),

                      child: DataTable(
                        columnSpacing: 150,

                        horizontalMargin: 40,

                        dataRowHeight: 75,

                        headingRowHeight: 70,

                        headingRowColor: WidgetStateProperty.all(
                          AppTheme.background,
                        ),

                        dataRowColor: WidgetStateProperty.all(AppTheme.surface),

                        dividerThickness: 0.5,

                        headingTextStyle: AppTheme.bodyLarge.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.bold,
                        ),

                        dataTextStyle: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.white,
                        ),

                        columns: const [
                          DataColumn(label: Text("Title")),

                          DataColumn(label: Text("Author")),

                          DataColumn(label: Text("Category")),

                          DataColumn(label: Text("Actions")),
                        ],

                        rows: books.map((book) {
                          return DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: 300,

                                  child: Text(
                                    book.title,

                                    overflow: TextOverflow.ellipsis,

                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),
                              ),

                              DataCell(
                                Text(
                                  book.authorId,

                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),

                              DataCell(
                                Text(
                                  book.categoryId,

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
                                        showBookDialog(
                                          context,
                                          ref,
                                          book: book,
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
                                            .read(bookProvider.notifier)
                                            .delete(book.id);
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

Future<void> showBookDialog(
  BuildContext context,
  WidgetRef ref, {
  BookModel? book,
}) async {
  final titleController = TextEditingController(text: book?.title ?? "");

  String selectedAuthor = book?.authorId ?? "";

  String selectedCategory = book?.categoryId ?? "";

  final editing = book != null;

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
              editing ? "Edit Book" : "Add Book",

              style: AppTheme.titleLarge.copyWith(color: AppTheme.white),
            ),

            content: SizedBox(
              width: 420,

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  TextField(
                    controller: titleController,

                    style: AppTheme.bodyLarge.copyWith(color: AppTheme.white),

                    decoration: inputDecoration("Book Title"),
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: selectedAuthor.isEmpty ? null : selectedAuthor,

                    dropdownColor: AppTheme.surface,

                    style: AppTheme.bodyLarge.copyWith(color: AppTheme.white),

                    decoration: inputDecoration("Author"),

                    items: authors.map((author) {
                      return DropdownMenuItem(
                        value: author.id,

                        child: Text(
                          author.name,

                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.white,
                          ),
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedAuthor = value ?? "";
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: selectedCategory.isEmpty ? null : selectedCategory,

                    dropdownColor: AppTheme.surface,

                    style: AppTheme.bodyLarge.copyWith(color: AppTheme.white),

                    decoration: inputDecoration("Category"),

                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,

                        child: Text(
                          category.name,

                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.white,
                          ),
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value ?? "";
                      });
                    },
                  ),
                ],
              ),
            ),

            actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: Text(
                  "Cancel",

                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,

                  foregroundColor: Colors.white,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                onPressed: () async {
                  final notifier = ref.read(bookProvider.notifier);

                  final id = titleController.text
                      .trim()
                      .toLowerCase()
                      .replaceAll(" ", "_");

                  await notifier.add(
                    BookModel(
                      id: editing ? book.id : id,

                      title: titleController.text.trim(),

                      authorId: selectedAuthor,

                      categoryId: selectedCategory,
                    ),
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },

                child: Text(
                  editing ? "Update" : "Save",

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
