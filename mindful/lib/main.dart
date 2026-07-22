import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routers/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDjNsjYEc_zgZclpxWYw0q9tZdUTot10ig",
      authDomain: "mindful-bbabf.firebaseapp.com",
      databaseURL: "https://mindful-bbabf-default-rtdb.firebaseio.com",
      projectId: "mindful-bbabf",
      storageBucket: "mindful-bbabf.firebasestorage.app",
      messagingSenderId: "776838516130",
      appId: "1:776838516130:web:bb60b0a44240b6d1b676fb",
      measurementId: "G-3RDJWHXCFE",
    ),
  );

  runApp(
    const ProviderScope(
      child: MindfulApp(),
    ),
  );
}

class MindfulApp extends StatelessWidget {
  const MindfulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Mindful',
      theme: ThemeData(
        scaffoldBackgroundColor: AppTheme.background,
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}