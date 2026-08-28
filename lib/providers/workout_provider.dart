import 'package:flutter/material.dart';
import '../models/timetable_block_model.dart';
import '../models/free_slot_model.dart';
import '../models/exercise_model.dart';
import '../data/exercise_library.dart';
import '../utils/date_time_helper.dart';

class WorkoutSlotPlan {
  final FreeSlot slot;
  final SplitType split;
  final List<Exercise> exercises;
  WorkoutSlotPlan({required this.slot, required this.split, required this.exercises});
}

class WorkoutProvider extends ChangeNotifier {
  static const List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // In-memory only — no persistence, matches the app's demo-only data policy
  final List<TimetableBlock> _blocks = [];
  List<TimetableBlock> get blocks => List.unmodifiable(_blocks);

  final Map<String, SplitType> _daySplit = {
    'Mon': SplitType.push,
    'Tue': SplitType.pull,
    'Wed': SplitType.legs,
    'Thu': SplitType.push,
    'Fri': SplitType.pull,
    'Sat': SplitType.core,
    'Sun': SplitType.rest,
  };
  Map<String, SplitType> get daySplit => _daySplit;

  int _idCounter = 0;

  void addBlock({required String day, required BlockType type, required int startMinutes, required int endMinutes}) {
    _blocks.add(TimetableBlock(id: 'b${_idCounter++}', day: day, type: type, startMinutes: startMinutes, endMinutes: endMinutes));
    notifyListeners();
  }

  void removeBlock(String id) {
    _blocks.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  void setSplitForDay(String day, SplitType split) {
    _daySplit[day] = split;
    notifyListeners();
  }

  List<TimetableBlock> blocksForDay(String day) => _blocks.where((b) => b.day == day).toList()
    ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

  List<WorkoutSlotPlan> planForDay(String day) {
    final split = _daySplit[day] ?? SplitType.rest;
    if (split == SplitType.rest) return [];

    final freeSlots = DateTimeHelper.freeSlotsForDay(blocksForDay(day));
    final pool = ExerciseLibrary.forSplit(split);
    if (pool.isEmpty) return [];

    final plans = <WorkoutSlotPlan>[];
    int poolOffset = 0;

    for (final slot in freeSlots) {
      final maxCount = (slot.durationMinutes / 5).floor().clamp(1, 4);
      final picked = <Exercise>[];
      for (int i = 0; i < maxCount; i++) {
        picked.add(pool[(poolOffset + i) % pool.length]);
      }
      poolOffset += maxCount;
      plans.add(WorkoutSlotPlan(slot: slot, split: split, exercises: picked));
    }
    return plans;
  }
}