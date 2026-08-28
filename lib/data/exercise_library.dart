import '../models/exercise_model.dart';
import '../models/rep_count_result_model.dart';

/// All exercises are bodyweight or minimal-equipment (resistance band / chair / wall) —
/// nothing needs a gym, matching the app's minimal-cost fitness goal.
class ExerciseLibrary {
  static const List<Exercise> push = [
    Exercise(name: 'Pushups', split: SplitType.push, prescription: '3 sets x 12 reps', estimatedMinutes: 5, trackableAs: ExerciseType.pushup),
    Exercise(name: 'Pike Pushups (shoulders)', split: SplitType.push, prescription: '3 sets x 10 reps', estimatedMinutes: 5),
    Exercise(name: 'Chair Tricep Dips', split: SplitType.push, prescription: '3 sets x 12 reps', estimatedMinutes: 4),
    Exercise(name: 'Wall/Incline Pushups', split: SplitType.push, prescription: '3 sets x 15 reps', estimatedMinutes: 4),
  ];

  static const List<Exercise> pull = [
    Exercise(name: 'Band Rows (or towel rows)', split: SplitType.pull, prescription: '3 sets x 12 reps', estimatedMinutes: 5),
    Exercise(name: 'Superman Holds', split: SplitType.pull, prescription: '3 sets x 20 sec', estimatedMinutes: 4),
    Exercise(name: 'Reverse Snow Angels', split: SplitType.pull, prescription: '3 sets x 15 reps', estimatedMinutes: 4),
    Exercise(name: 'Doorway Bicep Curls (band)', split: SplitType.pull, prescription: '3 sets x 12 reps', estimatedMinutes: 5),
  ];

  static const List<Exercise> legs = [
    Exercise(name: 'Bodyweight Squats', split: SplitType.legs, prescription: '3 sets x 15 reps', estimatedMinutes: 5, trackableAs: ExerciseType.squat),
    Exercise(name: 'Walking Lunges', split: SplitType.legs, prescription: '3 sets x 12 each leg', estimatedMinutes: 5),
    Exercise(name: 'Glute Bridges', split: SplitType.legs, prescription: '3 sets x 15 reps', estimatedMinutes: 4),
    Exercise(name: 'Wall Sit', split: SplitType.legs, prescription: '3 sets x 30 sec', estimatedMinutes: 4),
    Exercise(name: 'Calf Raises', split: SplitType.legs, prescription: '3 sets x 20 reps', estimatedMinutes: 3),
  ];

  static const List<Exercise> core = [
    Exercise(name: 'Sit-ups', split: SplitType.core, prescription: '3 sets x 15 reps', estimatedMinutes: 4),
    Exercise(name: 'Plank', split: SplitType.core, prescription: '3 sets x 30 sec', estimatedMinutes: 3),
    Exercise(name: 'Mountain Climbers', split: SplitType.core, prescription: '3 sets x 20 reps', estimatedMinutes: 4),
    Exercise(name: 'Leg Raises', split: SplitType.core, prescription: '3 sets x 12 reps', estimatedMinutes: 4),
  ];

  static List<Exercise> forSplit(SplitType split) {
    switch (split) {
      case SplitType.push: return push;
      case SplitType.pull: return pull;
      case SplitType.legs: return legs;
      case SplitType.core: return core;
      case SplitType.rest: return [];
    }
  }
}