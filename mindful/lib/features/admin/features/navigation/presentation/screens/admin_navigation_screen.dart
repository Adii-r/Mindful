import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/features/admin/features/game/presentation/screens/game_screen.dart';
import 'package:mindful/features/admin/features/quotes/presentation/screens/quotes_screen.dart';
import 'package:mindful/features/admin/features/users/presentation/screens/users_screen.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/admin_auth_provider.dart';
import '../../../auth/presentation/screens/admin_login_screen.dart';
import '../../../authors/presentation/screens/author_screen.dart';
import '../../../book/presentation/screens/books_screen.dart';
import '../../../category/presentation/screens/category_screen.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';



class AdminNavigationScreen extends ConsumerStatefulWidget {
  const AdminNavigationScreen({super.key});

  @override
  ConsumerState<AdminNavigationScreen> createState() =>
      _AdminNavigationScreenState();
}

class _AdminNavigationScreenState
    extends ConsumerState<AdminNavigationScreen> {
  int selectedIndex = 0;

  late final List<Widget> pages = [
    DashboardScreen(),
    CategoriesScreen(),
    AuthorsScreen(),
    BooksScreen(),
    QuotesScreen(),
    GamesAdminScreen(),
    UsersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Row(
        children: [
          Container(
            width: 270,
            color: AppTheme.surface,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 28,
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppTheme.primary,
                  child: Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 34,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  "Daily Bloom",
                  style: AppTheme.titleLarge.copyWith(
                    color: AppTheme.white,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "Administrator",
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),

                const SizedBox(height: 35),

                _buildNavItem(
                  index: 0,
                  icon: Icons.dashboard_rounded,
                  title: "Dashboard",
                ),

                _buildNavItem(
                  index: 1,
                  icon: Icons.category_rounded,
                  title: "Categories",
                ),

                _buildNavItem(
                  index: 2,
                  icon: Icons.person_outline,
                  title: "Authors",
                ),

                _buildNavItem(
                  index: 3,
                  icon: Icons.menu_book_rounded,
                  title: "Books",
                ),

                _buildNavItem(
                  index: 4,
                  icon: Icons.format_quote_rounded,
                  title: "Quotes",
                ),

                _buildNavItem(
                  index: 5,
                  icon: Icons.sports_esports_rounded,
                  title: "Game Content",
                ),

                _buildNavItem(
                  index: 6,
                  icon: Icons.people_outline,
                  title: "Users",
                ),

                const Spacer(),

                const Divider(color: AppTheme.hint),

                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: AppTheme.error,
                  ),
                  title: Text(
                    "Logout",
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.white,
                    ),
                  ),
                  onTap: () async {
                    await ref.read(adminRepositoryProvider).signOut();

                    if (!mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminLoginScreen(),
                      ),
                          (_) => false,
                    );
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: pages[selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String title,
  }) {
    final selected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color:
            selected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected
                    ? AppTheme.white
                    : AppTheme.textSecondary,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: AppTheme.bodyLarge.copyWith(
                  color: selected
                      ? AppTheme.white
                      : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}