import 'rep_record_model.dart';

enum ExerciseType { squat, pushup }
enum RepStage { up, down, unknown }

class RepCountResult {
  final int repCount;
  final RepStage stage;
  final double currentAngle;
  final String? formMessage;
  final RepRecord? completedRep; // only non-null on the exact frame a rep finishes

  RepCountResult({
    required this.repCount,
    required this.stage,
    required this.currentAngle,
    this.formMessage,
    this.completedRep,
  });
}