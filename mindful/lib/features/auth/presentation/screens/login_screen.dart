import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/primary_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_button.dart';



class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signInWithGoogle() async {
    setState(() => isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryProvider);

      final userCredential = await authRepository.signInWithGoogle();

      if (userCredential == null) {
        return;
      }

      if (!mounted) return;
      context.go('/home');

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? 'Google Sign-In Failed',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> signIn() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email and password.'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final authRepository = ref.read(authRepositoryProvider);

      await authRepository.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      context.go('/home');

    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-credential':
          message = 'Invalid email or password.';
          break;
        case 'user-not-found':
          message = 'No account found with this email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email.';
          break;
        case 'too-many-requests':
          message = 'Too many login attempts. Try again later.';
          break;
        default:
          message = e.message ?? 'Login failed.';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
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
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              "Log in for your next chat",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),

                            const SizedBox(height: 50),

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
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            PrimaryButton(
                              text: "Log In",
                              isLoading: isLoading,
                              onPressed: signIn,
                            ),

                            const SizedBox(height: 36),

                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: Colors.white24,
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    "OR CONTINUE WITH",
                                    style: AppTheme.caption.copyWith(
                                      color: AppTheme.textSecondary,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: Colors.white24,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            SocialButton(
                              text: "Continue with Google",
                              assetIcon: "assets/icons/google.png",
                              onPressed: signInWithGoogle,
                            ),

                            const SizedBox(height: 24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.go('/signup');
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppTheme.secondary,
                                      fontWeight: FontWeight.bold,
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