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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      department: json['department'],
      hostel: json['hostel'],
      points: json['points'] ?? 0,
      squadId: json['squadId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department': department,
      'hostel': hostel,
      'points': points,
      'squadId': squadId,
    };
  }
}