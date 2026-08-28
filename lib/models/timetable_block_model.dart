enum BlockType { classSession, food, selfStudy }

extension BlockTypeLabel on BlockType {
  String get label {
    switch (this) {
      case BlockType.classSession: return 'Class';
      case BlockType.food: return 'Food';
      case BlockType.selfStudy: return 'Self Study';
    }
  }
}

class TimetableBlock {
  final String id;
  final String day; // 'Mon', 'Tue', ...
  final BlockType type;
  final int startMinutes; // minutes since midnight
  final int endMinutes;

  TimetableBlock({
    required this.id,
    required this.day,
    required this.type,
    required this.startMinutes,
    required this.endMinutes,
  });
}