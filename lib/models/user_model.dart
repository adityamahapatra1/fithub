class UserModel {
  final String id;
  final String name;
  final String email;
  final String? department;
  final String? hostel;
  final int points;
  final String? squadId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.department,
    this.hostel,
    this.points = 0,
    this.squadId,
  });
}