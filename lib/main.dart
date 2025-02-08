import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'screens/splash_screen.dart';
import 'screens/team_entry_screen.dart';
import 'screens/team_info_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/team-entry',
      builder: (context, state) => const TeamEntryScreen(),
    ),
    GoRoute(
      path: '/team-info/:teamId',
      builder: (context, state) => TeamInfoScreen(
        teamId: state.pathParameters['teamId']!,
      ),
    ),
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Team Info App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: _router,
    );
  }
}