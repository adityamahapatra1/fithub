import '../models/timetable_block_model.dart';
import '../models/free_slot_model.dart';

class DateTimeHelper {
  static const int dayStartMinutes = 6 * 60; // 6:00 AM
  static const int dayEndMinutes = 23 * 60; // 11:00 PM
  static const int minUsefulGapMinutes = 15;

  static String minutesToLabel(int minutes) {
    final h24 = minutes ~/ 60;
    final m = minutes % 60;
    final period = h24 >= 12 ? 'PM' : 'AM';
    final h12 = h24 % 12 == 0 ? 12 : h24 % 12;
    return '${h12.toString()}:${m.toString().padLeft(2, '0')} $period';
  }

  /// Given a day's busy blocks, returns the free gaps within waking hours
  /// long enough to be useful for a micro-workout.
  static List<FreeSlot> freeSlotsForDay(List<TimetableBlock> dayBlocks) {
    final sorted = [...dayBlocks]..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
    final slots = <FreeSlot>[];
    int cursor = dayStartMinutes;

    for (final block in sorted) {
      if (block.startMinutes > cursor) {
        final gap = block.startMinutes - cursor;
        if (gap >= minUsefulGapMinutes) {
          slots.add(FreeSlot(startMinutes: cursor, endMinutes: block.startMinutes));
        }
      }
      cursor = block.endMinutes > cursor ? block.endMinutes : cursor;
    }

    if (dayEndMinutes > cursor && dayEndMinutes - cursor >= minUsefulGapMinutes) {
      slots.add(FreeSlot(startMinutes: cursor, endMinutes: dayEndMinutes));
    }
    return slots;
  }
}