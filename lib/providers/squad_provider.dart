import 'package:flutter/material.dart';
import '../models/squad_model.dart';

class SquadProvider extends ChangeNotifier {
  final SquadModel squad = SquadModel(
    id: 'sq1',
    name: 'Iron Titans',
    members: [
      SquadMember(name: 'You', streak: 5, completedToday: true),
      SquadMember(name: 'Aditi', streak: 7, completedToday: true),
      SquadMember(name: 'Rohan', streak: 2, completedToday: false),
      SquadMember(name: 'Priya', streak: 4, completedToday: false),
    ],
  );
}