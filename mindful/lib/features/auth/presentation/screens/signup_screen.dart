import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/primary_button.dart';
import '../widgets/primary_text_field.dart';
import '../widgets/social_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    if (usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryProvider);

      await authRepository.signUp(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseAuth.instance.currentUser?.updateDisplayName(
        usernameController.text.trim(),
      );

      if (!mounted) return;

      context.go('/preferences');
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'An account already exists.';
          break;

        case 'weak-password':
          message = 'Password is too weak.';
          break;

        case 'invalid-email':
          message = 'Invalid email.';
          break;

        default:
          message = e.message ?? "Registration failed.";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> signUpWithGoogle() async {
    setState(() => isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryProvider);

      final credential = await authRepository.signInWithGoogle();

      if (credential == null) return;

      if (!mounted) return;

      if (credential.additionalUserInfo?.isNewUser ?? false) {
        context.go('/preferences');
      } else {
        context.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Google Sign Up Failed")),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Create Account",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              "Start your mindful reading journey",
                              textAlign: TextAlign.center,
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),

                            const SizedBox(height: 40),

                            PrimaryTextField(
                              hintText: "Username",
                              controller: usernameController,
                            ),

                            const SizedBox(height: 20),

                            PrimaryTextField(
                              hintText: "Email",
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 20),

                            PrimaryTextField(
                              hintText: "Password",
                              controller: passwordController,
                              obscureText: obscurePassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            PrimaryButton(
                              text: "Create Account",
                              isLoading: isLoading,
                              onPressed: signUp,
                            ),

                            const SizedBox(height: 36),
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(color: Colors.black12),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    "OR CONTINUE WITH",
                                    style: AppTheme.caption.copyWith(
                                      color: AppTheme.textSecondary,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(color: Colors.black12),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            SocialButton(
                              text: "Continue with Google",
                              assetIcon: "assets/icons/google.png",
                              onPressed: signUpWithGoogle,
                            ),

                            const SizedBox(height: 30),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.go('/login');
                                  },
                                  child: Text(
                                    "Log In",
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppTheme.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
