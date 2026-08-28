import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class AngleCalculator {
  static const double _minLikelihood = 0.65;

  static double calculateAngle(PoseLandmark first, PoseLandmark mid, PoseLandmark last) {
    double radians = atan2(last.y - mid.y, last.x - mid.x) -
        atan2(first.y - mid.y, first.x - mid.x);
    double angle = (radians * 180.0 / pi).abs();
    if (angle > 180) angle = 360 - angle;
    return angle;
  }

  static bool _confident(PoseLandmark? l) => l != null && l.likelihood >= _minLikelihood;

  static double kneeAngle(Pose pose, {required bool leftSide}) {
    final hip = pose.landmarks[leftSide ? PoseLandmarkType.leftHip : PoseLandmarkType.rightHip];
    final knee = pose.landmarks[leftSide ? PoseLandmarkType.leftKnee : PoseLandmarkType.rightKnee];
    final ankle = pose.landmarks[leftSide ? PoseLandmarkType.leftAnkle : PoseLandmarkType.rightAnkle];
    if (!_confident(hip) || !_confident(knee) || !_confident(ankle)) return -1;
    return calculateAngle(hip!, knee!, ankle!);
  }

  static double elbowAngle(Pose pose, {required bool leftSide}) {
    final shoulder = pose.landmarks[leftSide ? PoseLandmarkType.leftShoulder : PoseLandmarkType.rightShoulder];
    final elbow = pose.landmarks[leftSide ? PoseLandmarkType.leftElbow : PoseLandmarkType.rightElbow];
    final wrist = pose.landmarks[leftSide ? PoseLandmarkType.leftWrist : PoseLandmarkType.rightWrist];
    if (!_confident(shoulder) || !_confident(elbow) || !_confident(wrist)) return -1;
    return calculateAngle(shoulder!, elbow!, wrist!);
  }

  /// True only if the joints needed for the given exercise are confidently visible.
  /// For squats, we need at least one full leg (hip, knee, ankle).
  /// For pushups, we need at least one full arm (shoulder, elbow, wrist).
  static bool isBodyReadyFor(Pose pose, {required bool isSquat}) {
    if (isSquat) {
      final leftLeg = _confident(pose.landmarks[PoseLandmarkType.leftHip]) &&
          _confident(pose.landmarks[PoseLandmarkType.leftKnee]) &&
          _confident(pose.landmarks[PoseLandmarkType.leftAnkle]);
      final rightLeg = _confident(pose.landmarks[PoseLandmarkType.rightHip]) &&
          _confident(pose.landmarks[PoseLandmarkType.rightKnee]) &&
          _confident(pose.landmarks[PoseLandmarkType.rightAnkle]);
      return leftLeg || rightLeg;
    } else {
      final leftArm = _confident(pose.landmarks[PoseLandmarkType.leftShoulder]) &&
          _confident(pose.landmarks[PoseLandmarkType.leftElbow]) &&
          _confident(pose.landmarks[PoseLandmarkType.leftWrist]);
      final rightArm = _confident(pose.landmarks[PoseLandmarkType.rightShoulder]) &&
          _confident(pose.landmarks[PoseLandmarkType.rightElbow]) &&
          _confident(pose.landmarks[PoseLandmarkType.rightWrist]);
      return leftArm || rightArm;
    }
  }
}