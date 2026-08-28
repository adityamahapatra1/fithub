import 'rep_count_result_model.dart'; // reuse ExerciseType (squat/pushup) for AI-trackable ones

enum SplitType { push, pull, legs, core, rest }

extension SplitTypeLabel on SplitType {
  String get label {
    switch (this) {
      case SplitType.push: return 'Push Day';
      case SplitType.pull: return 'Pull Day';
      case SplitType.legs: return 'Leg Day';
      case SplitType.core: return 'Core Day';
      case SplitType.rest: return 'Rest Day';
    }
  }
}

class Exercise {
  final String name;
  final SplitType split;
  final String prescription; // e.g. "3 sets x 12 reps"
  final int estimatedMinutes;
  final ExerciseType? trackableAs; // non-null if AI rep counter supports it

  const Exercise({
    required this.name,
    required this.split,
    required this.prescription,
    required this.estimatedMinutes,
    this.trackableAs,
  });
}