import 'package:flutter/material.dart';
import '../models/leaderboard_entry_model.dart';

class LeaderboardTile extends StatelessWidget {
  final LeaderboardEntry entry;
  const LeaderboardTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final isYou = entry.name == 'You';
    return Card(
      color: isYou ? Colors.deepPurple.shade50 : null,
      child: ListTile(
        leading: CircleAvatar(child: Text('${entry.rank}')),
        title: Text(entry.name, style: TextStyle(fontWeight: isYou ? FontWeight.bold : FontWeight.normal)),
        subtitle: Text(entry.department),
        trailing: Text('${entry.points} pts', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}