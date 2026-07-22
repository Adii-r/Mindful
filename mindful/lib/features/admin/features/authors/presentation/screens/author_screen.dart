import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/author_model.dart';
import '../../../category/data/models/category_model.dart';
import '../providers/author_provider.dart';
import '../../../category/presentation/providers/category_provider.dart';

class AuthorsScreen extends ConsumerWidget {
  const AuthorsScreen({super.key});

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,

      hintStyle: AppTheme.bodyMedium.copyWith(color: AppTheme.hint),

      filled: true,

      fillColor: AppTheme.background,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authors = ref.watch(authorProvider);

    final categories = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,

        foregroundColor: Colors.white,

        onPressed: () {
          showAuthorDialog(context, ref);
        },

        icon: const Icon(Icons.add),

        label: const Text("Add Author"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Authors",

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
                    constraints: const BoxConstraints(minWidth: 1400),

                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),

                      child: DataTable(
                        columnSpacing: 160,

                        horizontalMargin: 40,

                        dataRowMinHeight: 70,

                        dataRowMaxHeight: 70,

                        headingRowHeight: 70,

                        headingTextStyle: AppTheme.bodyLarge.copyWith(
                          color: AppTheme.white,

                          fontWeight: FontWeight.bold,
                        ),

                        dataTextStyle: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textPrimary,
                        ),

                        columns: const [
                          DataColumn(label: Text("Name")),

                          DataColumn(label: Text("Bio")),

                          DataColumn(label: Text("Category")),

                          DataColumn(label: Text("Actions")),
                        ],

                        rows: authors.map((author) {
                          final category = categories.firstWhere(
                            (c) => c.id == author.categoryId,

                            orElse: () => CategoryModel(
                              id: "",
                              name: "Unknown",
                              icon: "",
                            ),
                          );

                          return DataRow(
                            cells: [
                              DataCell(Text(author.name)),

                              DataCell(
                                SizedBox(
                                  width: 300,

                                  child: Text(
                                    author.bio,

                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),

                              DataCell(Text(category.name)),

                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,

                                        color: Colors.orange,
                                      ),

                                      onPressed: () {
                                        showAuthorDialog(
                                          context,

                                          ref,

                                          author: author,
                                        );
                                      },
                                    ),

                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,

                                        color: Colors.red,
                                      ),

                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,

                                          builder: (_) {
                                            return AlertDialog(
                                              title: const Text(
                                                "Delete Author",
                                              ),

                                              content: const Text(
                                                "Are you sure?",
                                              ),

                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      context,
                                                      false,
                                                    );
                                                  },

                                                  child: const Text("Cancel"),
                                                ),

                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      context,
                                                      true,
                                                    );
                                                  },

                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirm == true) {
                                          await ref
                                              .read(authorProvider.notifier)
                                              .delete(author.id);
                                        }
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

Future<void> showAuthorDialog(
  BuildContext context,
  WidgetRef ref, {

  AuthorModel? author,
}) async {
  final nameController = TextEditingController(text: author?.name ?? "");

  final bioController = TextEditingController(text: author?.bio ?? "");

  String selectedCategory = author?.categoryId ?? "";

  final editing = author != null;

  await showDialog(
    context: context,

    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final categories = ref.watch(categoryProvider);

          return AlertDialog(
            backgroundColor: AppTheme.surface,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),

            title: Text(
              editing ? "Edit Author" : "Add Author",

              style: AppTheme.titleLarge.copyWith(color: AppTheme.white),
            ),

            content: SizedBox(
              width: 420,

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  TextField(
                    controller: nameController,

                    style: const TextStyle(color: Colors.white),

                    decoration: InputDecoration(
                      hintText: "Author Name",

                      filled: true,

                      fillColor: AppTheme.background,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: bioController,

                    maxLines: 3,

                    style: const TextStyle(color: Colors.white),

                    decoration: InputDecoration(
                      hintText: "Biography",

                      filled: true,

                      fillColor: AppTheme.background,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: categories.any((c) => c.id == selectedCategory)
                        ? selectedCategory
                        : null,

                    dropdownColor: AppTheme.surface,

                    decoration: InputDecoration(
                      labelText: "Category",

                      filled: true,

                      fillColor: AppTheme.background,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),

                        borderSide: BorderSide.none,
                      ),
                    ),

                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,

                        child: Text(
                          category.name,

                          style: const TextStyle(color: Colors.white),
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

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text("Cancel"),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
                onPressed: () async {
                  final notifier = ref.read(authorProvider.notifier);

                  if (editing) {
                    await notifier.update(
                      AuthorModel(
                        id: author.id,

                        name: nameController.text.trim(),

                        bio: bioController.text.trim(),

                        categoryId: selectedCategory,
                      ),
                    );
                  } else {
                    final id = nameController.text
                        .trim()
                        .toLowerCase()
                        .replaceAll(" ", "_");

                    await notifier.add(
                      AuthorModel(
                        id: id,

                        name: nameController.text.trim(),

                        bio: bioController.text.trim(),

                        categoryId: selectedCategory,
                      ),
                    );
                  }

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },

                child: Text(
                  editing ? "Update" : "Save",

                  style: const TextStyle(color: Colors.white
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
