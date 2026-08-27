import 'package:flutter/material.dart';
import '../models/squad_model.dart';
import 'streak_badge.dart';

class SquadMemberCard extends StatelessWidget {
  final SquadMember member;
  const SquadMemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(member.name[0])),
        title: Text(member.name),
        subtitle: Text(member.completedToday ? 'Completed today ✅' : 'Not done yet ⏳'),
        trailing: StreakBadge(streak: member.streak),
      ),
    );
  }
}