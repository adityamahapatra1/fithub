import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/squad_provider.dart';
import 'providers/leaderboard_provider.dart';
import 'providers/workout_provider.dart';
import 'providers/pose_provider.dart';
import 'screens/auth/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SquadProvider()),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => PoseProvider()),
      ],
      child: MaterialApp(
        title: 'Fitness Squad',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
        home: const LoginScreen(),
      ),
    );
  }
}