class FreeSlot {
  final int startMinutes;
  final int endMinutes;
  int get durationMinutes => endMinutes - startMinutes;
  FreeSlot({required this.startMinutes, required this.endMinutes});
}