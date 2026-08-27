import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/leaderboard_provider.dart';
import '../../widgets/leaderboard_tile.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<LeaderboardProvider>().entries;
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Leaderboard')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        itemBuilder: (context, i) => LeaderboardTile(entry: entries[i]),
      ),
    );
  }
}