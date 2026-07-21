import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/profile_provider.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_header.dart';



class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool isLoading = true;

  dynamic profile;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    profile = await ref.read(profileProvider).getProfile();
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> logout() async {
    await ref.read(profileProvider).signOut();

    if (!mounted) return;

    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "PROFILE",
          style: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.w900,
            fontSize: 24,
            letterSpacing: 6,
            color: Colors.white,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [

              ProfileAvatar(
                photoUrl: profile.photoUrl,
                name: profile.name,
              ),

              const SizedBox(height: 20),

              ProfileHeader(
                name: profile.name,
                email: profile.email,
              ),

              const SizedBox(height: 32),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your Interests",
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: profile.interests.map<Widget>((interest) {
                  return Chip(
                    avatar: Text(
                      interest["icon"],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    label: Text(
                      interest["name"],
                    ),
                    backgroundColor: AppTheme.primary,
                    labelStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.push('/preferences');
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text("Edit Interests"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: AppTheme.primary,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              LogoutButton(
                onPressed: logout,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}