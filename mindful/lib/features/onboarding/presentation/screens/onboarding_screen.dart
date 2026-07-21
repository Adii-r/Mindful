import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/primary_button.dart';
import '../../data/models/category_model.dart';
import '../widgets/interest_chip.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends ConsumerState<OnboardingScreen> {
  List<CategoryModel> categories = [];
  List<String> selectedInterests = [];
  bool isLoading = true;

  Future<void> loadCategories() async {
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child('categories')
        .get();

    if (!snapshot.exists) {
      setState(() => isLoading = false);
      return;
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    categories = data.entries.map((entry) {
      return CategoryModel(
        id: entry.key,
        name: entry.value['name'],
        iconUrl: entry.value['iconUrl'],
      );
    }).toList();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> continueToHome() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseDatabase.instance
        .ref()
        .child('user_preferences')
        .child(uid)
        .set({
      'categoryIds': selectedInterests,
    });

    if (!mounted) return;

    context.go('/home');
  }

  void toggleInterest(String id) {
    setState(() {
      if (selectedInterests.contains(id)) {
        selectedInterests.remove(id);
      } else {
        if (selectedInterests.length < 10) {
          selectedInterests.add(id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = selectedInterests.length >= 3;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),

              Text(
                "Choose Your Interests",
                textAlign: TextAlign.center,
                style: AppTheme.displayLarge.copyWith(
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Pick at least 3 interests to personalize your recommendations.",
                textAlign: TextAlign.center,
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "${selectedInterests.length} of 3 selected",
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 28),

              Expanded(
                child: isLoading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : SingleChildScrollView(
                  child: Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: categories.map((category) {
                        return InterestChip(
                          title: "${category.iconUrl} ${category.name}",
                          isSelected: selectedInterests.contains(category.id),
                          onTap: () => toggleInterest(category.id),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              PrimaryButton(
                text: "Continue",
                onPressed: canContinue
                    ? continueToHome
                    : null,
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}