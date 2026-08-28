import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../utils/angle_calculator.dart';
import '../models/rep_count_result_model.dart';
import '../models/rep_record_model.dart';

class RepCounterService {
  final ExerciseType exerciseType;
  RepCounterService({required this.exerciseType});

  int _repCount = 0;
  RepStage _stage = RepStage.unknown;
  double _minAngleThisRep = 999;
  double _maxAngleThisRep = -999;

  static const double _downThreshold = 100;
  static const double _upThreshold = 160;
  static const double _idealRange = 100; // expected full range of motion

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

    _minAngleThisRep = min(_minAngleThisRep, angle);
    _maxAngleThisRep = max(_maxAngleThisRep, angle);

    String? formMessage;
    RepRecord? completedRep;

    if (angle <= _downThreshold) {
      _stage = RepStage.down;
    } else if (angle >= _upThreshold && _stage == RepStage.down) {
      _stage = RepStage.up;
      _repCount++;

      final romAchieved = (_maxAngleThisRep - _minAngleThisRep).clamp(0, _idealRange);
      final romPercent = (romAchieved / _idealRange * 100).clamp(0, 100).toDouble();
      final formScore = romPercent; // real proxy: fuller range = better form
      final valid = formScore >= 60;

      completedRep = RepRecord(
        repNumber: _repCount,
        romPercent: romPercent,
        formScore: formScore,
        valid: valid,
        feedback: _feedbackFor(formScore),
      );

      _minAngleThisRep = 999;
      _maxAngleThisRep = -999;
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
      completedRep: completedRep,
    );
  }

  String _feedbackFor(double score) {
    if (score >= 85) return 'Excellent rep!';
    if (score >= 70) return 'Good job!';
    if (score >= 50) return 'Decent — go a bit deeper next time';
    return 'Try to complete full range of motion';
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
    _minAngleThisRep = 999;
    _maxAngleThisRep = -999;
  }
}