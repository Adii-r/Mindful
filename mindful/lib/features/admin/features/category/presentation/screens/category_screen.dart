import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/category_model.dart';
import '../providers/category_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          showCategoryDialog(context, ref);
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Category"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Categories",
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
                    constraints: const BoxConstraints(minWidth: 1250),

                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),

                      child: DataTable(
                        columnSpacing: 180,
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

                          DataColumn(label: Text("Icon")),

                          DataColumn(label: Text("Actions")),
                        ],

                        rows: categories.map((category) {
                          return DataRow(
                            cells: [
                              DataCell(Text(category.name)),

                              DataCell(
                                Text(
                                  category.icon,
                                  style: const TextStyle(fontSize: 24),
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
                                        showCategoryDialog(
                                          context,
                                          ref,
                                          category: category,
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
                                                "Delete Category",
                                              ),

                                              content: const Text(
                                                "Are you sure you want to delete this category?",
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
                                              .read(categoryProvider.notifier)
                                              .delete(category.id);
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

Future<void> showCategoryDialog(
  BuildContext context,
  WidgetRef ref, {
  CategoryModel? category,
}) async {
  final nameController = TextEditingController(text: category?.name ?? "");

  final iconController = TextEditingController(text: category?.icon ?? "");

  final editing = category != null;

  await showDialog(
    context: context,

    builder: (context) {
      return AlertDialog(
        backgroundColor: AppTheme.surface,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),

        title: Text(
          editing ? "Edit Category" : "Add Category",

          style: AppTheme.titleLarge.copyWith(color: AppTheme.white),
        ),

        content: SizedBox(
          width: 420,

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller: nameController,

                style: AppTheme.bodyLarge.copyWith(color: Colors.white),

                decoration: InputDecoration(
                  labelText: "Category Name",

                  filled: true,

                  fillColor: AppTheme.background,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: iconController,

                style: AppTheme.bodyLarge.copyWith(color: Colors.white),

                decoration: InputDecoration(
                  labelText: "Emoji",

                  filled: true,

                  fillColor: AppTheme.background,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
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
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),

            onPressed: () async {
              final notifier = ref.read(categoryProvider.notifier);

              if (editing) {
                await notifier.update(
                  CategoryModel(
                    id: category.id,

                    name: nameController.text.trim(),

                    icon: iconController.text.trim(),
                  ),
                );
              } else {
                final id = nameController.text.trim().toLowerCase().replaceAll(
                  " ",
                  "_",
                );

                await notifier.add(
                  CategoryModel(
                    id: id,

                    name: nameController.text.trim(),

                    icon: iconController.text.trim(),
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
}
