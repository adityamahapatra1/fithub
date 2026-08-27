import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../utils/angle_calculator.dart';
import '../models/rep_count_result_model.dart';

class RepCounterService {
  final ExerciseType exerciseType;
  RepCounterService({required this.exerciseType});

  int _repCount = 0;
  RepStage _stage = RepStage.unknown;

  static const double _downThreshold = 100;
  static const double _upThreshold = 160;

  int get repCount => _repCount;

  RepCountResult? processPose(Pose pose) {
    double angle;
    if (exerciseType == ExerciseType.squat) {
      angle = _avg(
        AngleCalculator.kneeAngle(pose, leftSide: true),
        AngleCalculator.kneeAngle(pose, leftSide: false),
      );
    } else {
      angle = _avg(
        AngleCalculator.elbowAngle(pose, leftSide: true),
        AngleCalculator.elbowAngle(pose, leftSide: false),
      );
    }

    if (angle < 0) return null;

    String? formMessage;

    if (angle <= _downThreshold) {
      _stage = RepStage.down;
    } else if (angle >= _upThreshold && _stage == RepStage.down) {
      _stage = RepStage.up;
      _repCount++;
    } else if (angle >= _upThreshold) {
      _stage = RepStage.up;
    }

    if (angle > _downThreshold + 10 && angle < _upThreshold - 10) {
      formMessage = 'Go further for a full rep';
    }

    return RepCountResult(
      repCount: _repCount,
      stage: _stage,
      currentAngle: angle,
      formMessage: formMessage,
    );
  }

  double _avg(double a, double b) {
    if (a < 0 && b < 0) return -1;
    if (a < 0) return b;
    if (b < 0) return a;
    return (a + b) / 2;
  }

  void reset() {
    _repCount = 0;
    _stage = RepStage.unknown;
  }
}