import 'package:flutter/material.dart';
import '../models/timetable_block_model.dart';
import '../utils/date_time_helper.dart';

class TimetableBlockTile extends StatelessWidget {
  final TimetableBlock block;
  final VoidCallback onDelete;
  const TimetableBlockTile({super.key, required this.block, required this.onDelete});

  Color get _color {
    switch (block.type) {
      case BlockType.classSession: return const Color(0xFF5C6BC0);
      case BlockType.food: return const Color(0xFFFFA726);
      case BlockType.selfStudy: return const Color(0xFF66BB6A);
    }
  }

  IconData get _icon {
    switch (block.type) {
      case BlockType.classSession: return Icons.school;
      case BlockType.food: return Icons.restaurant;
      case BlockType.selfStudy: return Icons.menu_book;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: _color.withValues(alpha: 0.15), child: Icon(_icon, color: _color, size: 20)),
        title: Text(block.type.label),
        subtitle: Text('${DateTimeHelper.minutesToLabel(block.startMinutes)} - ${DateTimeHelper.minutesToLabel(block.endMinutes)}'),
        trailing: IconButton(icon: const Icon(Icons.close, size: 18), onPressed: onDelete),
      ),
    );
  }
}