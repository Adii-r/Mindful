import 'package:go_router/go_router.dart';
import 'package:mindful/features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),

    GoRoute(
      path: '/signup',
      builder: (context, state) => SignupScreen(),
    ),


    GoRoute(
      path: '/preferences',
      builder: (context, state) => OnboardingScreen(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
  ],
);