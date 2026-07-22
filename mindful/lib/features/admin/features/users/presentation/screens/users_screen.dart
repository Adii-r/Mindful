import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';

import '../providers/user_provider.dart';
import '../../data/models/user_model.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,

      body: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Users",

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
                    constraints: const BoxConstraints(minWidth: 1200),

                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),

                      child: DataTable(
                        columnSpacing: 120,

                        horizontalMargin: 40,

                        headingRowHeight: 70,

                        dataRowHeight: 75,

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
                          DataColumn(label: Text("Name")),

                          DataColumn(label: Text("Email")),

                          DataColumn(label: Text("Provider")),

                          DataColumn(label: Text("Role")),

                          DataColumn(label: Text("Joined")),

                          DataColumn(label: Text("Actions")),
                        ],

                        rows: users.map((user) {
                          return DataRow(
                            cells: [
                              DataCell(Text(user.displayName)),

                              DataCell(Text(user.email)),

                              DataCell(Text(user.authProvider)),

                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,

                                    vertical: 8,
                                  ),

                                  decoration: BoxDecoration(
                                    color: user.role == "admin"
                                        ? Colors.green.withOpacity(.15)
                                        : Colors.blue.withOpacity(.15),

                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  child: Text(
                                    user.role,

                                    style: TextStyle(
                                      color: user.role == "admin"
                                          ? Colors.green
                                          : Colors.blue,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              DataCell(Text(user.createdAt)),

                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.admin_panel_settings,

                                        color: Colors.orange,
                                      ),

                                      onPressed: () {
                                        showRoleDialog(context, ref, user);
                                      },
                                    ),

                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,

                                        color: Colors.red,
                                      ),

                                      onPressed: () async {
                                        await ref
                                            .read(userProvider.notifier)
                                            .delete(user.id);
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

Future<void> showRoleDialog(
  BuildContext context,

  WidgetRef ref,

  UserModel user,
) async {
  String role = user.role;

  await showDialog(
    context: context,

    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppTheme.surface,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),

            title: Text(
              "Change Role",

              style: AppTheme.titleLarge.copyWith(color: AppTheme.white),
            ),

            content: DropdownButtonFormField<String>(
              value: role,

              dropdownColor: AppTheme.surface,

              style: AppTheme.bodyLarge.copyWith(color: AppTheme.white),

              decoration: InputDecoration(
                filled: true,

                fillColor: AppTheme.background,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),

                  borderSide: BorderSide.none,
                ),
              ),

              items: [
                DropdownMenuItem(
                  value: "user",

                  child: Text("User", style: TextStyle(color: Colors.white)),
                ),

                DropdownMenuItem(
                  value: "admin",

                  child: Text("Admin", style: TextStyle(color: Colors.white)),
                ),
              ],

              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: Text("Cancel", style: TextStyle(color: AppTheme.hint)),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),

                onPressed: () async {
                  await ref
                      .read(userProvider.notifier)
                      .changeRole(user.id, role);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },

                child: const Text(
                  "Save",

                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
