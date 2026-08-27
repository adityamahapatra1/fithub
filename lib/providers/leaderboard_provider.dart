import 'package:flutter/material.dart';
import '../models/leaderboard_entry_model.dart';

class LeaderboardProvider extends ChangeNotifier {
  final List<LeaderboardEntry> entries = [
    LeaderboardEntry(name: 'Aditi Sharma', department: 'ECE', points: 480, rank: 1),
    LeaderboardEntry(name: 'Rohan Gupta', department: 'CSE', points: 410, rank: 2),
    LeaderboardEntry(name: 'You', department: 'CSE', points: 120, rank: 3),
    LeaderboardEntry(name: 'Priya Singh', department: 'ME', points: 95, rank: 4),
  ];
}