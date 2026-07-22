import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 34,
            color: AppTheme.primary,
          ),
          const SizedBox(height: 18),
          Text(
            value,
            style: AppTheme.displayLarge.copyWith(
              color: AppTheme.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: dashboard.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text(
            e.toString(),
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.error,
            ),
          ),
        ),
        data: (data) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dashboard",
                  style: AppTheme.headlineLarge.copyWith(
                    color: AppTheme.white,
                  ),
                ),

                const SizedBox(height: 35),

                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.5,
                  children: [
                    _buildCard(
                      title: "Categories",
                      value: data.categories.toString(),
                      icon: Icons.category,
                    ),
                    _buildCard(
                      title: "Authors",
                      value: data.authors.toString(),
                      icon: Icons.person,
                    ),
                    _buildCard(
                      title: "Books",
                      value: data.books.toString(),
                      icon: Icons.menu_book,
                    ),
                    _buildCard(
                      title: "Quotes",
                      value: data.quotes.toString(),
                      icon: Icons.format_quote,
                    ),
                    _buildCard(
                      title: "Games",
                      value: data.games.toString(),
                      icon: Icons.videogame_asset,
                    ),
                    _buildCard(
                      title: "Users",
                      value: data.users.toString(),
                      icon: Icons.people,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}