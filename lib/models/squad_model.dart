class SquadMember {
  final String name;
  final int streak;
  final bool completedToday;

  SquadMember({required this.name, required this.streak, required this.completedToday});
}

class SquadModel {
  final String id;
  final String name;
  final List<SquadMember> members;

  SquadModel({required this.id, required this.name, required this.members});
}