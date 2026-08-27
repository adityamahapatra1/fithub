import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/squad_provider.dart';
import '../../widgets/squad_member_card.dart';

class SquadScreen extends StatelessWidget {
  const SquadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final squad = context.watch<SquadProvider>().squad;
    return Scaffold(
      appBar: AppBar(title: Text(squad.name)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: squad.members.length,
        itemBuilder: (context, i) => SquadMemberCard(member: squad.members[i]),
      ),
    );
  }
}