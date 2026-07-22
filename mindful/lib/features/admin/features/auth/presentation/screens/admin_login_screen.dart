import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/features/admin/features/navigation/presentation/screens/admin_navigation_screen.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../providers/admin_auth_provider.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() =>
      _AdminLoginScreenState();
}

class _AdminLoginScreenState
    extends ConsumerState<AdminLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    try {
      setState(() {
        isLoading = true;
      });

      final repository = ref.read(adminRepositoryProvider);

      final credential = await repository.signIn(
        email: emailController.text,
        password: passwordController.text,
      );

      final isAdmin =
      await repository.isAdmin(credential.user!.uid);

      if (!isAdmin) {
        await repository.signOut();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unauthorized Access"),
          ),
        );

        return;
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminNavigationScreen(),
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid email or password"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTheme.bodyMedium.copyWith(
        color: AppTheme.hint,
      ),
      filled: true,
      fillColor: AppTheme.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppTheme.primary,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 430,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/icon.png",
                  height: 90,
                ),

                const SizedBox(height: 5),

                Text(
                  "Admin Login",
                  style: AppTheme.headlineLarge.copyWith(
                    color: AppTheme.white,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Manage Daily Bloom",
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),

                const SizedBox(height: 36),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: emailController,
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration(
                    "admin@email.com",
                  ),
                ),

                const SizedBox(height: 22),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.white,
                  ),
                  decoration: inputDecoration(
                    "••••••••",
                  ),
                ),

                const SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: AppTheme.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppTheme.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : Text(
                      "Log In",
                      style: AppTheme.button.copyWith(
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}