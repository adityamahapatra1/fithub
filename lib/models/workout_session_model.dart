class WorkoutSuggestion {
  final String title;
  final String timeSlot;
  final int durationMinutes;
  final String exercise; // 'squat' or 'pushup'

  WorkoutSuggestion({
    required this.title,
    required this.timeSlot,
    required this.durationMinutes,
    required this.exercise,
  });
}