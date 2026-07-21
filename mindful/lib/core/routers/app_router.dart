import 'package:go_router/go_router.dart';

import '../../auth/presentation/screens/login_screen.dart';
import '../../auth/presentation/screens/signup_screen.dart';

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

    /*
    GoRoute(
      path: '/preferences',
      builder: (context, state) => PreferencesScreen(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),

     */
  ],
);