import 'package:go_router/go_router.dart';
import 'package:mindful/features/admin/features/auth/presentation/screens/admin_login_screen.dart';
import 'package:mindful/features/admin/features/navigation/presentation/screens/admin_navigation_screen.dart';
import 'package:mindful/features/navigation/presentation/screens/navigation_screen.dart';
import 'package:mindful/features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/admin-login', //'/login',
  routes: [

    GoRoute(
      path: '/admin-login',
      builder: (context, state) => AdminLoginScreen(),
    ),

    GoRoute(
      path: '/admin',
      builder: (context, state) => AdminNavigationScreen(),
    ),

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
      builder: (context, state) => NavigationScreen(),
    ),
  ],
);