enum ExerciseType { squat, pushup }
enum RepStage { up, down, unknown }

class RepCountResult {
  final int repCount;
  final RepStage stage;
  final double currentAngle;
  final String? formMessage;

  RepCountResult({
    required this.repCount,
    required this.stage,
    required this.currentAngle,
    this.formMessage,
  });
}